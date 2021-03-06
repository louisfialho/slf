class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  def move_to_space_list
    $spaces = []

    shelf = current_user.shelves.first
    spaces_on_shelf = shelf.spaces #this can be changed using order by, for instance to display most popular spaces!

    for s in spaces_on_shelf do
      if s.connections.empty? == false
        connections = s.connections
        recursive_space_search(connections)
      else
        $spaces << s
      end
    end

    return $spaces
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

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
