class SpacesController < ApplicationController
  def new
    if params[:shelf_id].present?
      @space = Space.new
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:parent_id].present?
      @parent = Space.find(params[:parent_id])
      @child = Space.new
    end
  end

  def create
    if params[:space][:shelf_id].present?
      @space = Space.new(space_params)
      @space.save
      @shelf = Shelf.find(params[:space][:shelf_id])
      @shelf.spaces << @space
      redirect_to space_path(@space)
    elsif params[:space][:parent_id].present?
      @child = Space.new(space_params)
      @child.save
      @parent = Space.find(params[:space][:parent_id])
      s1 = Connection.create(space: @parent)
      s2 = s1.children.create(space: @child)
      redirect_to space_path(@parent)
    end
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
