class ShelvesController < ApplicationController
  before_action :set_shelf, only: [:show, :edit, :update, :destroy]

  def new
    @shelf = Shelf.new
  end

  def create
    @shelf = Shelf.new(shelf_params)
    @shelf.save
    current_user.shelves << @shelf
    redirect_to shelf_path(@shelf)
  end

  def index
    @shelves = Shelf.all
  end

  def show
    @spaces = Space.all
  end

  def edit
  end

  def update
    @shelf.update(shelf_params)
    redirect_to shelf_path(@shelf)
  end

  def destroy
    @shelf.spaces.each do |space|
      ids = []
      ids << space.id
      sc = Connection.where(space_id: space.id).first
      sc.descendants.reverse.each do |descendant|
        ids << descendant.space.id # a refactorer car la même méthode est dans le controller spaces
      end
      Space.where(id: ids).destroy_all
    end
    @shelf.destroy
    redirect_to shelves_path
  end

  private

  def shelf_params
    params.require(:shelf).permit(:name, :description)
  end

  def set_shelf
    @shelf = Shelf.find(params[:id])
  end
end
