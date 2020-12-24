class SpacesController < ApplicationController
  def new
    @space = Space.new
  end

  def create
    @space = Space.new(space_params)
    @space.save
    redirect_to space_path(@space)
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
