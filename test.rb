require File.expand_path('config/environment', __dir__)

client = Twilio::REST::Client.new
  client.messages.create({
    from: '+15035494537',
    to: '+33625019332',
    body: 'Hello there! This is a test'
})
