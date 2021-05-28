class SessionsController < Devise::SessionsController
  alias :super_create :create
  alias :super_new :new

  def create
    super do |user|
      if user.persisted?
        chrome_auth_token = user.chrome_auth_token
        cookies.permanent[:chrome_auth_token] = chrome_auth_token
      end
    end
  end

  def new_ext
    super_new()
  end

  def create_ext
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    if @user.persisted?
      chrome_auth_token = @user.chrome_auth_token
      cookies.permanent[:chrome_auth_token] = chrome_auth_token
    end
    respond_with resource, location: sessions_start_extension_path
  end

  def start_extension
  end
end
