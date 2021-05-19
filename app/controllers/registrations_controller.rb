class RegistrationsController < Devise::RegistrationsController
# skip_after_action :verify_authorized, only: [:stat_telegram_chat_id]

  def stat_telegram_chat_id
    if current_user
      @user = current_user
      render json: {is_nil: @user.telegram_chat_id.nil?}
    end
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
      render json: {shelf_id: @user.shelves.first.id}
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      message_new_user = "Welcome to Shelf #{@user.first_name}!
Please open the link below to open your first conversation with Shelf Bot in Telegram.
Once in Telegram, simply hit 'Start'.
https://t.me/Shelf_bot?start=#{@user.telegram_hash}
N.B. If you don't have the Telegram app installed, please do install it in order to join Shelf!"
      TwilioClient.new.send_text(@user.phone_number, message_new_user)
      UserNotifierMailer.send_signup_email(@user).deliver
      UserNotifierMailer.inform_louis_of_user_signup(@user).deliver
      redirect_to meet_bot_path
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new
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

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :phone_number, :email, :password, :password_confirmation)
  end
end

