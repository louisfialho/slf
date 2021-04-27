class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  def move_to_space_list
    if user_signed_in?
      shelf = current_user.shelves.first
      shelf.spaces.sort_by {|space| space.position}
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

  helper_method :move_to_space_list

  def pundit_user
    CurrentContext.new(current_user, current_context)
  end

  def current_context
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
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
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

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
