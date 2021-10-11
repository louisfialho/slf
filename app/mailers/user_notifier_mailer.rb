class UserNotifierMailer < ApplicationMailer
  default :from => 'louis@shelf.so'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email, :subject => 'Add your first resource to your Shelf 📚' )
  end

  def set_up_telegram(user)
    @user = user
    mail( :to => @user.email, :subject => 'Connect with Shelf Bot on Telegram 🤖' )
  end

  def install_chrome_ext(user)
    @user = user
    mail( :to => @user.email, :subject => "Add resources from desktop using Shelf's Chrome extension! 🧠", :bcc => 'louis@shelf.so' )
  end

  def inform_louis_of_user_signup(user)
    @user = user
    mail( :to => 'louis@shelf.so', :subject => 'New user 🧒' )
  end

  def inform_louis_of_new_item(item, user, origin)
    @item = item
    @user = user
    @origin = origin
    mail( :to => 'louis@shelf.so', :subject => 'New item 📚' )
  end

  def inform_louis_of_new_space(space, user)
    @space = space
    @user = user
    mail( :to => 'louis@shelf.so', :subject => 'New space 🗄' )
  end

  def inform_louis_of_new_audio(user, minutes)
    @user = user
    @minutes = minutes
    mail( :to => 'louis@shelf.so', :subject => 'New audio 👂' )
  end
end
