class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery prepend: true

  include Pundit

  # The 3 following methods update_balance_temp and final should not be in the application controller and shouuld be in a standalone controller
  # in routes, remove the 3 post methods at the bottom
  # below, remove except: [ :update_balance_temp, :update_balance_final, ...]

  def update_balance_temp
    if current_user
      current_user.tts_balance_in_min -= params[:approx_minutes].to_f
      current_user.save
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end

  def update_balance_final
    if current_user
      current_user.tts_balance_in_min += params[:approx_minutes].to_f
      current_user.tts_balance_in_min -= params[:actual_minutes].to_f
      current_user.save
      respond_to do |format|
        format.json { head :ok }
      end
      UserNotifierMailer.inform_louis_of_new_audio(current_user, params[:actual_minutes]).deliver_later
    end
  end

  def pay_back_balance
    if current_user
      current_user.tts_balance_in_min += params[:approx_minutes].to_f
      current_user.save
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end

  def user_balance
    if current_user
      render json: {balance: current_user.tts_balance_in_min}
    end
  end

  def move_item_to_space_list
    @shelf_mother = shelf_mother_of_item(@item)
    @shelf_mother.spaces.sort_by {|space| space.position}
  end

  def move_space_to_space_list
    @shelf_mother = shelf_mother_of_space(@space)
    @shelf_mother.spaces.sort_by {|space| space.position}
  end

  def shelf_mother_of_space(space)
    @space = space
    if @space.shelves.empty? == false
      @space.shelves.first
    else
      recursive_parent_search3(@space).shelves.first
    end
  end

  def shelf_mother_of_item(item)
    if @item.shelves.empty? == false
      @item.shelves.first
    elsif @item.spaces.empty? == false
      recursive_parent_search3(@item.spaces.first).shelves.first
    end
  end

  def recursive_space_search(array_of_connections)
    for c in array_of_connections do
      $spaces << c.space
      if c.space.children.empty? == false
        children = c.space.children
        recursive_space_search(children)
      end
    end
  end

  helper_method :move_item_to_space_list, :move_space_to_space_list

  def pundit_user
    CurrentContext.new(current_user, current_context)
  end

  def current_context # Purpose of this block?? Slows down page loads!!
    if params[:space].present?
      if params[:space][:parent_id].present?
        context = ['parent', Space.find(params[:space][:parent_id])]
      elsif params[:space][:shelf_id].present?
        context = ['shelf', Shelf.find(params[:space][:shelf_id])]
      end
    elsif params[:item].present?
      if params[:item][:shelf_id].present?
        context = ['shelf', Shelf.find(params[:item][:shelf_id])]
      elsif params[:item][:parent_id].present?
        context = ['parent', Space.find(params[:item][:parent_id])]
      end
    elsif params[:parent_id].present?
      context = ['parent', Space.find(params[:parent_id])]
    elsif params[:shelf_id].present?
      context = ['shelf', Shelf.find(params[:shelf_id])]
    elsif params[:id].present?
      if params[:controller] == 'shelves'
        context = ['shelf', Shelf.find(params[:id])]
      elsif params[:controller] == 'spaces'
        context = ['parent', Space.find(params[:id])]
      end
    end
  end

  # Pundit: white-list approach.
  after_action :verify_authorized, except: [:index, :update_balance_temp, :update_balance_final, :user_balance, :pay_back_balance], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  def recursive_parent_search3(space)
    while space.shelves.empty?
      space.connections.each do |connection|
        if connection.parent_id.nil? == false
          @connection = connection
        end
      end
      space = @connection.parent.space
    end
    return space
  end

  def after_sign_in_path_for(resource)
    shelf_path(current_user.shelves.first.username)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end


  protected
    def configure_permitted_parameters
         devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :username, :phone_number, :email, :password)}
         devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :username, :phone_number, :email, :password, :current_password)}
    end
end
