class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    if @user.persisted?
      # use @user.telegram_hash
      # @user.first_name
      #https://t.me/Shelf_bot?start=vCH1vGWJxfSeofSAs0K5PA
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

