# frozen_string_literal: true
require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'

class SearchTest < Minitest::Test
  def test_search_word
    content = URI.open('https://www.ldoceonline.com/dictionary/apple')&.read
    doc = Nokogiri::HTML(content)
    word = Word.new
    doc.css('.dictlink .ldoceEntry').each do |link|
      doc.css(".Head .PronCodes").each do |word_sound|
        # 音标
        word.sound = word_sound.content
        break
      end

      doc.css(".Sense .DEF").each do |word_explain|
        # 描述
        word.sound = word_explain.content
        break
      end

      examples = []
      doc.css(".Sense .EXAMPLE").each do |word_explain|
        # 描述
        examples << word_explain.content.strip.chomp
      end
      word.sound = examples.join("#")
      break
    end
  end

  def test_search_wrong_word
    content = URI.open('https://www.ldoceonline.com/dictionary/xxx')&.read
    doc = Nokogiri::HTML(content)
    doc.css('.search_title').each do |link|
      assert_equal("Sorry, there are no results for xxx",link.content)
    end
  end
end
