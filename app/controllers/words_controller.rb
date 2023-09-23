require 'nokogiri'
require 'open-uri'
class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  def search
    row_word = params[:search]
    word = do_search(row_word)
    p "word : #{word.nil?}"
    if word.nil?
      redirect_to words_path, notice: "单词找不到啊"
    else
      redirect_to words_path, notice: "单词已经被成功添加" if word.save
    end
  end

  def index
    @words = Word.ordered
  end

  def show
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)

    if @word.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @word.update(word_params)
      redirect_to words_path, notice: "word was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_path, notice: "Quote was successfully destroyed." }
      format.turbo_stream
    end
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
    doc.css('.search_title').each do |link|
      return link.content.start_with?("Sorry, there are no results for")
    end
    false
  end
end
