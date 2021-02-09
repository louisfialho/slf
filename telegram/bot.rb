require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'
require 'uri'
require 'open-uri'
require 'nokogiri'

token = '1659215816:AAHxfbWMVqVK7r52W04LrjSiEEgA6ZHM7f8'

def item_name(url)
  html_file = open(url)
  html_doc = Nokogiri::HTML(html_file)
  if url.include? 'www.youtube'
    return html_doc.at('meta[name="title"]')['content'] # works for YouTube
  else
    return html_doc.css('head title').inner_text # works for spotify and more
  end
  # does not work for Techcrunch
end

def item_medium(url)
  if url.include? 'www.youtube'
    return 'video'
  elsif url.include? 'spotify.com/episode'
    return 'podcast'
  elsif url.include? 'www.amazon'
    return 'book'
  else
    return 'other'
  end
end

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
      item_name = item_name(url)
      item_medium = item_medium(url)
      user = User.find_by(email: email)
      shelf = user.shelves.first
      item = Item.new(url: url, medium: item_medium, name: item_name, status: 'not started', rank: 'medium')
      shelf.items << item
      bot.api.send_message(chat_id: message.chat.id, text: "#{item_name} was added to your shelf! Check it out! https://www.shelf.so/items/#{item.id}?shelf_id=#{shelf.id}")
    end
  end
end


