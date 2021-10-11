class ShelvesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_shelf, only: [:show, :edit, :update, :destroy]
  skip_after_action :verify_authorized, only: [:shelf_children]

  def to_param
    username
  end

  def create
    @shelf = Shelf.new(shelf_params)
    authorize @shelf
    @shelf.save
    current_user.shelves << @shelf
    redirect_to shelf_path(@shelf)
  end

  # def index
  #   @shelves = policy_scope(Shelf)
  #   @space = Space.new
  # end

  # def shelf
  #   @shelf = Shelf.find_by user_id: current_user.id
  #   authorize @shelf
  #   shelf_id = @shelf.id
  #   redirect_to action: "show", id: shelf_id
  # end

  def show
    @spaces = Space.all
    @space = Space.new
    @item = Item.new
    if current_user
      @user = current_user
    end
  end

  # def edit
  # end

  # def update
  #   @shelf.update(shelf_params)
  #   redirect_to shelf_path(@shelf)
  # end

  # def destroy
  #   @shelf.spaces.each do |space|
  #     ids = []
  #     ids << space.id
  #     sc = Connection.where(space_id: space.id).first
  #     if !sc.descendants.empty?
  #       sc.descendants.reverse.each do |descendant|
  #         ids << descendant.space.id # a refactorer car la même méthode est dans le controller spaces
  #       end
  #     end
  #     Space.where(id: ids).destroy_all
  #   end
  #   @shelf.destroy
  #   redirect_to shelves_path
  # end

  def shelf_children
    shelf = current_user.shelves.first
    shelf_children = shelf.spaces.sort_by {|space| space.position}
    render json: {shelf_children: shelf_children}
  end

  private

  def shelf_params
    params.require(:shelf).permit(:user_id)
  end

  def set_shelf
    @shelf = Shelf.find_by(username: params[:username])
    authorize @shelf
  end
end
