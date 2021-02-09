require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'

token = '1659215816:AAHxfbWMVqVK7r52W04LrjSiEEgA6ZHM7f8'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
