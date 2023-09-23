require 'nokogiri'
require 'open-uri'
class WordsController < ApplicationController
  def search
    row_word = params[:search].to_s.downcase
    @word = do_search(row_word)
    if @word.nil?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("flash", partial: "layouts/flash", locals: { message: flash.now[:notice] = "单词找不到啊" })
        end
      end
    else
      if @word.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [turbo_stream.prepend("words", @word, locals: { message: flash.now[:notice] = "单词已经被成功加入！！！" }),turbo_stream.prepend("flash", partial: "layouts/flash")]
          end
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
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_path, notice: "Quote was successfully destroyed." }
      format.turbo_stream
    end
  end

  private
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
end
