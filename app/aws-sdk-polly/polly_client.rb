class PollyClient
  attr_reader :client

  require 'aws-sdk'

  def initialize
    client = Aws::Polly::Client.new(
      region: ENV['AWS_REGION']
    )
  end

  def text_to_speech(text)
    resp = client.synthesize_speech({
      output_format: "mp3",
      #sample_rate: "8000",
      text: text,
      #text_type: "text",
      voice_id: "Matthew",
    })
    #err
  end
end


