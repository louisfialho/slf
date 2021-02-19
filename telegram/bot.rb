require File.expand_path('../config/environment', __dir__)

require 'net/http'
require 'telegram/bot'
require 'uri'
require 'open-uri'
require 'nokogiri'


token = ENV['TELEGRAM_TOKEN']

# def item_name(url)
#   html_file = URI.open(url)
#   html_doc = Nokogiri::HTML(html_file)
#   if url.include? 'www.youtube'
#     return html_doc.at('meta[name="title"]')['content'] # works for YouTube
#   else
#     return html_doc.css('head title').inner_text # works for spotify and more
#   # does not work for Techcrunch
#   end
# end

# def item_medium(url)
#   if url.include? 'www.youtube'
#     return 'video'
#   elsif url.include?('spotify.com/episode') || url.include?('podcasts.apple')
#     return 'podcast'
#   elsif url.include? 'www.amazon'
#     return 'book'
#   else
#     return 'other'
#   end
# end

# def uri?(string)
#   uri = URI.parse(string)
#   %w( http https ).include?(uri.scheme)
# rescue URI::BadURIError
#   false
# rescue URI::InvalidURIError
#   false
# end

# def working_url?(url_str)
#   Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
#   rescue
#     false
# end


# def is_redirect?(url_str)
#   Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPRedirection)
#   rescue
#     false
# end

# def final_url(url_str)
#   URI.open(url_str) do |resp|
#     return resp.base_uri.to_s
#   end
# end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message.text
      if message.text == '/start' || message.text.include?('/start ')
        unique_code = message.text.split[1] # add condition if exists
        #si il y a unique_code
        if unique_code.to_s.strip.empty? == false
        #  si ce unique_code correspond à un user
          if User.find_by(telegram_hash: unique_code).nil? == false
        #  ajouter message.chat.id à ce user
            user = User.find_by(telegram_hash: unique_code)
            user.telegram_chat_id = message.chat.id
            user.save
            bot.api.send_message(chat_id: message.chat.id, text: "Hi #{message.from.first_name}, send me a URL and I'll add the object to your shelf!")
        #  si ce unique code ne correspond pas à un user
          else
        #  je ne sais pas qui vous êtes...
            bot.api.send_message(chat_id: message.chat.id, text: "Sorry #{message.from.first_name}, I cannot find you.")
          end
        #si il n'y a pas unique_code
        else
          #demander de se connecter avec un lien envoyé par mail pr identifier
          bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, please use the link sent by mail to open your first discussion with Shelf bot")
        end
      elsif message.text == '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Ciao #{message.text}")
      else
        if User.find_by(telegram_chat_id: message.chat.id).nil? == false
          user = User.find_by(telegram_chat_id: message.chat.id)
          shelf = user.shelves.first
          item = Item.create(url: message.text.to_s)
          if item.valid? == false
            if item.errors[:url] == ["is not a URL"]
              bot.api.send_message(chat_id: message.chat.id, text: "Sorry #{message.from.first_name}, but I don't understand what you are saying... Please only send me plain URLs so that I can add the corresponding object to your Shelf! 💆‍♂️")
            elsif item.errors[:url] == ["is not a valid URL"]
              bot.api.send_message(chat_id: message.chat.id, text: "Mmh... This URL doesn't seem to be valid! Please only send me valid URLs 💆‍♂️")
            end
          else
            shelf.items << item
            bot.api.send_message(chat_id: message.chat.id, text: "This object was added to your shelf! Check it out! https://www.shelf.so/items/#{item.id}?shelf_id=#{shelf.id}")
          end
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Sorry #{message.from.first_name}, I cannot find you. Please try to open this chat using the link provided by Shelf so that I can know who you are! 💆‍♂️")
        end
      end
    end
  end
end
