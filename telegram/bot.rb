require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'
require "uri"

token = '1659215816:AAHxfbWMVqVK7r52W04LrjSiEEgA6ZHM7f8'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}. Send me a message with your e-mail and a URL, and I'll add the object to your shelf!")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    else
      email = message.text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i).first
      url = URI.extract(message.text).first
      user = User.find_by(email: email)
      shelf = user.shelves.first
      item = Item.new(url: url, medium: 'other', name: 'added from Telegram', status: 'not started', rank: 'medium')
      shelf.items << item
      bot.api.send_message(chat_id: message.chat.id, text: "Your object was added to your shelf! Check it out!")
    end
  end
end
