class TwilioClient
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def send_text(dest_phone_num, message)
    client.messages.create(
      to: dest_phone_num,
      from: '+15035494537',
      body: message
    )
  end

  private

    def account_sid
      ENV['TWILIO_ACCOUNT_SID']
    end

    def auth_token
      ENV['TWILIO_AUTH_TOKEN']
    end
end
