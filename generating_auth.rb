require File.expand_path('config/environment', __dir__)

  chrome_auth_token = loop do
    random_token = SecureRandom.urlsafe_base64(nil, false)
    break random_token unless User.exists?(chrome_auth_token: random_token)
  end
  p chrome_auth_token

