class UserNotifierMailer < ApplicationMailer
  default :from => 'louis@shelf.so'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email, :subject => 'Connect with Shelf Bot 🤖' )
  end

  def inform_louis_of_user_signup(user)
    @user = user
    mail( :to => 'louis@shelf.so', :subject => 'New user 🧒' )
  end
end
