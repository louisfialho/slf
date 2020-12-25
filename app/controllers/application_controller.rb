class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def destroy_children(space)
    ids = []
    ids << @space.id
    sc = Connection.where(space_id: @space.id).first
    sc.descendants.reverse.each do |descendant|
      ids << descendant.space.id
    end
    Space.where(id: ids).destroy_all
    redirect_to root_path #not perfect: should redirect to shelf
  end
end
