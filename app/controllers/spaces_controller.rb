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
    redirect_to space_path(@space)
  end

  def index
    @spaces = Space.all
  end

  def show
    @space = Space.find(params[:id])
  end

  def edit
    @space = Space.find(params[:id])
  end

  def update
    @space = Space.find(params[:id])
    @space.update(space_params)
    redirect_to space_path(@space)
  end

  def destroy
    @space = Space.find(params[:id])
    @space.destroy
    redirect_to root_path #not perfect: should redirect to shelf
  end

  private

  def space_params
    params.require(:space).permit(:name, :description)
  end
end
