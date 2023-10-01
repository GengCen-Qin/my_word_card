# frozen_string_literal: true

class GuessOtherWordError < StandardError
  attr_reader :doc
  def initialize(doc)
    @doc = doc
  end
end
