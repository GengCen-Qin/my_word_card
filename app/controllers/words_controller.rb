require 'nokogiri'
require 'open-uri'

class WordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def search
    row_word = params[:search].to_s.downcase

    @word = Word.find_by_name(row_word)
    if @word
      @word.update(updated_at: DateTime.now)
      return respond_to do |format|
        format.turbo_stream
      end
    end

    @word = do_search(row_word)
    if @word
      if @word.save
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = "单词被成功创建了！！！" }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("flash", partial: "layouts/flash", locals: { message: flash.now[:notice] = "单词找不到啊" })
        end
      end
    end
  end

  def index
    @words = Word.ordered
  end

  def show
  end

  def destroy
    set_word
    @word.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.remove(@word),
                              turbo_stream.prepend("flash", partial: "layouts/flash", locals: { message: flash.now[:notice] = "单词成功删除！！！" })]
      end
    end
  end

  def makeMessageByAI
    render plain: get_ai_message
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name, :sound, :explain, :example)
  end

  def do_search(content)
    body = URI.open("https://www.ldoceonline.com/dictionary/#{content.to_s.strip.chomp}")&.read
    doc = Nokogiri::HTML(body)
    return nil if check_is_wrong_word?(doc)
    word = Word.new
    word.name = content.to_s.strip.chomp
    doc.css('.dictlink .ldoceEntry').each do |link|
      doc.css(".Head .speaker").each do |word_sound_mp3|
        word.word_sound_link = word_sound_mp3["data-src-mp3"]
        break
      end

      doc.css(".Head .PronCodes").each do |word_sound|
        # 音标
        word.sound = word_sound.content
        break
      end

      doc.css(".Sense .DEF").each do |word_explain|
        # 描述
        word.explain = word_explain.content
        break
      end

      examples = []
      doc.css(".Sense .EXAMPLE").each do |word_explain|
        # 举例
        examples << word_explain.content.strip.chomp
      end
      word.example = examples.join("#")
      break
    end
    word
  end

  def check_is_wrong_word?(doc)
    is_wrong_word = false
    doc.css('.search_title').each do |link|
      # 如果提示Did you mean:，应该优化为给出一些待选选项
      is_wrong_word = link.content.start_with?("Sorry, there are no results for") || link.content.start_with?("Did you mean:")
    end
    is_wrong_word
  end

  def get_ai_message
    word_names = Word.pluck(:name)
    prompt = "I will provide you with a few words and ask you to use them to generate a short, easily understandable article \
              because I'm curious about how these words are used in real-life situations.. It would be great if the article could \
              be limited to around 100 words.
              Words: #{word_names}"
    client = OpenAI::Client.new
    result = "AI暂时无法访问"
    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: prompt }],
          temperature: 0.5,
        })
      result = response.dig("choices", 0, "message", "content")
    rescue => e
      logger.error("openAi request fail: #{e}")
    end
    result
  end
end
