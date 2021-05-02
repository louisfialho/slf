class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    if @user.persisted?
      # send this sms
      # "Welcome to Shelf @user.first_name, please open the link below to open your first conversation with Shelf Bot in Telegram.
      # Once in Telegram, simply hit "Start".
      # https://t.me/Shelf_bot?start= @user.telegram_hash
      # If you don't have the Telegram app installed, please do install it in order to join Shelf!
  end

  def meet_bot
  end

  def shake_hands
  end

  def after_sign_up_path_for(resource)
    meet_bot_path
  end
  end
end

