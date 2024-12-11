require 'nokogiri'
require 'open-uri'
require 'securerandom'
require_relative '../exceptions/guess_other_word_error'
require_relative '../exceptions/not_found_word_error'

class WordsController < ApplicationController
  include ActionController::Live
  skip_before_action :verify_authenticity_token

  def search
    row_word = params[:search].to_s.downcase

    @word = Word.find_by_name(row_word)
    if @word
      update_session(@word)
      @word.update(updated_at: DateTime.now)
      return respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "移动到顶部啦！！！" }
      end
    end

    begin
      @word = do_search(row_word)
      if @word.save
        update_session(@word)
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = "单词被成功创建了！！！" }
        end
      end
    rescue NotFoundWordError
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "单词找不到啊！！！" }
      end
    rescue GuessOtherWordError => e
      @similar_words = []
      e.doc.css(".didyoumean li a").each do |word|
        @similar_words << word.content.to_s.strip.chomp
      end
      flash[:similar_words] = @similar_words
      flash.now[:notice] = "你是否查询下列单词！！！"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("flash", partial: "layouts/flash"),
            turbo_stream.update("similar_list", partial: "words/similar_list", locals: { words: @similar_words })
          ]
        end
      end
    end
  end

  def index
    @similar_words = flash[:similar_words]
    ids = session[:ids]
    if ids.nil? || ids.to_a.empty?
      @words = Word.none
      session[:ids] = []
      session[:key] = SecureRandom.random_number
    else
      @words = Word.where(id: ids).order(updated_at: :desc)
    end
  end

  def destroy
    set_word
    ids = session[:ids]
    ids.delete(@word.id)
    session[:ids] = ids
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.remove(@word),
                              turbo_stream.prepend("flash", partial: "layouts/flash", locals: { message: flash.now[:notice] = "单词成功删除！！！" })]
      end
    end
  end

  def make_message_by_ai
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Last-Modified'] = Time.now.httpdate
    sse = SSE.new(response.stream, retry: 300)
    begin
      prompt = Word.pluck(:name)
      result = ''
      OpenAiClient.chat_stream(prompt) do |chunk|
        sse.write(status: 200, content: result.concat(chunk))
      end
    ensure
      sse.close
    end
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def do_search(content)
    body = URI.open("https://www.ldoceonline.com/dictionary/#{content.to_s.strip.chomp}")&.read
    doc = Nokogiri::HTML(body)
    case check_word_status(doc)
    when :not_found
      raise(NotFoundWordError)
    when :guess_other
      raise(GuessOtherWordError.new(doc))
    else
      @word = Word.new
      @word.name = content.to_s.strip.chomp
      doc.css('.dictlink .ldoceEntry').each do |link|
        doc.css(".Head .speaker").each do |word_sound_mp3|
          @word.word_sound_link = word_sound_mp3["data-src-mp3"]
          break
        end

        doc.css(".Head .PronCodes").each do |word_sound|
          # 音标
          @word.sound = word_sound.content
          break
        end

        doc.css(".Sense .DEF").each do |word_explain|
          # 描述
          @word.explain = word_explain.content
          break
        end

        examples = []
        doc.css(".Sense .EXAMPLE").each do |word_explain|
          # 举例
          examples << word_explain.content.strip.chomp
        end
        @word.example = examples.join("#")
        break
      end
    end
    @word
  end

  def check_word_status(doc)
    status = :success
    doc.css('.search_title').each do |link|
      status = :not_found if link.content.start_with?("Sorry, there are no results for")
      status = :guess_other if link.content.start_with?("Did you mean:")
    end
    status
  end

  def update_session(word)
    ids = session[:ids]
    ids.delete(word.id)
    ids.prepend(word.id)
    session[:ids] = ids
  end
end
