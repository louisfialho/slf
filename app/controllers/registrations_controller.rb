class RegistrationsController < Devise::RegistrationsController
# skip_after_action :verify_authorized, only: [:stat_telegram_chat_id]

  def stat_telegram_chat_id
    if current_user
      @user = current_user
    end
    render json: {is_nil: @user.telegram_chat_id.nil?}
  end

  def stat_added_first_item
    if current_user
      @user = current_user
      render json: {shelf_empty: @user.shelves.first.spaces.first.items.empty?}
    end
  end

  def current_shelf
    if current_user
      @user = current_user
    end
    render json: {shelf_id: @user.shelves.first.id}
  end

  def create
    super
    if @user.persisted?
      message_new_user = "Welcome to Shelf #{@user.first_name}!
Please open the link below to open your first conversation with Shelf Bot in Telegram.
Once in Telegram, simply hit 'Start'.
https://t.me/Shelf_bot?start=#{@user.telegram_hash}
N.B. If you don't have the Telegram app installed, please do install it in order to join Shelf!"
      message_louis = "New user! #{@user.first_name @user.last_name}, with username #{@user.username} just registered.
Make sure everything is fine #{@user.email} or #{@user.phone_number}"
      TwilioClient.new.send_text(@user.phone_number, message_new_user)
      TwilioClient.new.send_text('+33625019332'), message_louis)
    end
  end

  def meet_bot
  end

  def shake_hands
  end

  def add_first_resource
  end

  def after_sign_up_path_for(resource)
    meet_bot_path
  end
end

