module OpenAiClient
  def self.client
    @client ||= OpenAI::Client.new(
      access_token: ENV.fetch('OPENAI_ACCESS_TOKEN'),
      uri_base: ENV.fetch('OPENAI_URI_BASE')
    )
  end

  def self.chat(prompt)
    response = client.chat(
      parameters: {
        model: "deepseek-chat",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.5,
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
