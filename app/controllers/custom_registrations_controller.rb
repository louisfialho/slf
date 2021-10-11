class CustomRegistrationsController < Devise::RegistrationsController
  after_action :after_sign_up, :only => :create

  def after_sign_up
    @user = User.last
    chrome_auth_token = @user.chrome_auth_token
    cookies.permanent[:chrome_auth_token] = chrome_auth_token
    UserNotifierMailer.send_signup_email(@user).deliver
    UserNotifierMailer.inform_louis_of_user_signup(@user).deliver
  end
end
