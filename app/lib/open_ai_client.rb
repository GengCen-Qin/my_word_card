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
        temperature: 0.8,
      }
    )
    response.dig("choices", 0, "message", "content")
  end

  def self.chat_stream(prompt)
    response = client.chat(parameters: {
      model: 'deepseek-chat',
      messages: [
        { "role": "system", "content": ENV.fetch('PROMPT') },
        { role: "user", content: "Words: #{prompt}" }
      ],
      stream: proc do |chunk, _bytesize|
        content = chunk.dig("choices", 0, "delta", "content")
        yield content if content
      end
    })
  end
end
