class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  def index
    @words = Word.all
  end

  def show
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)

    if @word.save
      redirect_to words_path, notice: "word was successfully created."
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
    redirect_to words_path, notice: "word was successfully destroyed."
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name)
  end
end
