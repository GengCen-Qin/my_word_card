# frozen_string_literal: true
require "application_system_test_case"

class OpenAITest < ApplicationSystemTestCase

  test "Showing a quote" do
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: "Hello!" }],
        temperature: 0.7,
      })
    puts response.dig("choices", 0, "message", "content")
  end
end
