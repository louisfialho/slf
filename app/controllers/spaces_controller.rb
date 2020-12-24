class SpacesController < ApplicationController
  def new
    @space = Space.new
    @shelf = Shelf.find(params[:shelf_id])
  end

  def create
    @space = Space.new(space_params)
    @space.save
    @shelf = Shelf.find(params[:space][:shelf_id])
    @shelf.spaces << @space
    redirect_to space_path(@space, shelf_id: @shelf.id)
  end

  def index
    @spaces = Space.all
  end

  def show
    @space = Space.find(params[:id])
  end

  private

  def space_params
    params.require(:space).permit(:name, :description)
  end
end
