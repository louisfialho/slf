class RegistrationsController < Devise::RegistrationsController
  def meet_bot
  end

  def create
    super
    if @user.persisted?
      message_sync = "Welcome to Shelf #{@user.first_name}!
Please open the link below to open your first conversation with Shelf Bot in Telegram.
Once in Telegram, simply hit 'Start'.
https://t.me/Shelf_bot?start=#{@user.telegram_hash}
N.B. If you don't have the Telegram app installed, please do install it in order to join Shelf!"
      TwilioClient.new.send_text(@user.phone_number, message_sync)
    end
  end

  def shake_hands
  end

  def after_sign_up_path_for(resource)
    meet_bot_path
  end
end

