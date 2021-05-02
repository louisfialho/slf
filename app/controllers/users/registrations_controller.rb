class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def meet_bot
  end

  def after_sign_up_path_for(resource)
    meet_bot_path
  end

end

