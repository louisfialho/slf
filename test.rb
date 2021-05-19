require File.expand_path('config/environment', __dir__)

  def valid_phone_num
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    phone_number = @client.lookups.v1.phone_numbers('0000').fetch
    rescue
      record.errors.add(phone_number, "is not a valid phone number")
  end

valid_phone_num
