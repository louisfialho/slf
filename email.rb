require File.expand_path('config/environment', __dir__)

User.all.each do |user|
  p user.email
  p "Welcome to Shelf #{user.first_name} - Louis here!

  If you did not receive our SMS, please open this link from mobile to connect with Shelf Telegram Bot.
  https://t.me/Shelf_bot?start=#{user.telegram_hash}
  Once in Telegram, simply hit 'Start'.

  Traffic from HN took the SMS API down - sorry about that!
  Let me know how the onboarding goes - I'm here to help!
  Can't wait to see your first resource on your shelf.

  Happy learning 🧠
  Louis"
end
