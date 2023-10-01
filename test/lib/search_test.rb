# frozen_string_literal: true
require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'
require "application_system_test_case"
require_relative '../../app/models/word'

class SearchTest < Minitest::Test
  def test_search_word
    content = URI.open('https://www.ldoceonline.com/dictionary/apple')&.read
    doc = Nokogiri::HTML(content)
    word = Word.new
    doc.css('.dictlink .ldoceEntry').each do |link|
      doc.css(".Head .speaker").each do |word_sound_mp3|
        p "喇叭 ： #{word_sound_mp3["data-src-mp3"]}"
      end

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
      p "结果: #{link.content}"
      assert_equal("Sorry, there are no results for xxx",link.content)
    end
  end

  def test_search_similar_word
    content = URI.open('https://www.ldoceonline.com/dictionary/iphone')&.read
    doc = Nokogiri::HTML(content)
    doc.css(".didyoumean li a").each do |word|
      p "可能得单词有：#{word.content.to_s.strip.chomp}"
    end
  end
end
