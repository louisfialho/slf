require File.expand_path('../config/environment', __dir__)

require 'net/http'
require 'telegram/bot'
require 'uri'
require 'open-uri'
require 'nokogiri'

token = ENV['TELEGRAM_TOKEN']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message
      p message
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
            bot.api.send_message(chat_id: message.chat.id, text: "Hi #{message.from.first_name}, send me a resource and I'll add the object to your shelf! In order to send me a resource (a podcast, news article, video, Tweet… or any URL that can be shared), simply open it from your phone and hit Share > Telegram > Shelf")
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
            if shelf.spaces.empty? == false
              if shelf.spaces.where(name: "🤖 Added by Bot").length == 1 #user did not create another one nor deleted it
                space = shelf.spaces.where(name: "🤖 Added by Bot").first
                space.items.update_all('position = position + 1')
                space.children.each do |connection|
                  connection.space.position += 1
                  connection.space.save
                end
                if space.items.empty? && (shelf.spaces.length == 1) && (shelf.spaces.first.name == "🤖 Added by Bot") && shelf.items.empty?
                  space.items << item
                  item.notes = "Congratulations - you just added your first resource! 🎉
• All resources added from Telegram will be stored in the space 'Added by Bot 🤖'. Note that you can also add resources from desktop either by using the Telegram desktop app, or by adding resources directly in Shelf (go back to your Shelf, click on Options > New > Object and paste the URL).
• You can use this space as your to-do list. You can drag and reorder resources in order to prioritize. Once you finish a resource, you can archive it by adding it to a new space (once on the object, click on Options > Move to > New...). Go ahead and try to move this object to a new space!
• Finally, you can add notes to retain key insights. Try removing those notes and adding your own!
Hopefully this basic workflow will help you learn more 🧠! We would love to get in touch - send feedback 👋 louis@shelf.so"
                  item.save
                else
                  space.items << item
                end
                bot.api.send_message(chat_id: message.chat.id, text: "#{item.name} was added to your shelf! Check it out! https://www.shelf.so/items/#{item.id}?space_id=#{space.id} ")
              else
                shelf.items.update_all('position = position + 1')
                shelf.spaces.update_all('position = position + 1')
                shelf.items << item
                bot.api.send_message(chat_id: message.chat.id, text: "#{item.name} was added to your shelf! Check it out! https://www.shelf.so/items/#{item.id}?shelf_id=#{shelf.id} ")
              end
            end
          end
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Sorry #{message.from.first_name}, I cannot find you. Please try to open this chat using the link provided by Shelf so that I can know who you are! 💆‍♂️")
        end
      end
    end
  end
end
