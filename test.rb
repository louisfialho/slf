require File.expand_path('config/environment', __dir__)
require 'aws-sdk'

  client = Aws::Polly::Client.new(
    region: ENV['AWS_REGION']
  )

  text = "This is a test made by Louis, one of the founders of Shelf"

  resp = client.synthesize_speech({
    output_format: "mp3",
    #sample_rate: "8000",
    text: text,
    #text_type: "text",
    voice_id: "Matthew",
  })

  IO.copy_stream(resp.audio_stream, '/Users/louisfialho/Desktop/test.mp3')


