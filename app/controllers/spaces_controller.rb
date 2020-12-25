class SpacesController < ApplicationController
before_action :set_space, only: [:show, :edit, :update, :destroy]

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
      if !@parent.shelves.empty?
        s1 = Connection.create(space: @parent)
        s2 = s1.children.create(space: @child)
      else
        s2 = @parent.connections.first.children.create(space: @child)
      end
      redirect_to space_path(@parent)
    end
  end

  # not dry!
  # if space.shelves is not empty (meaning the parent space is the root)
  # set the space to parent (connection to nil) and the new space to child
  # if space.shelves is empty (meaning the parent space is nested)
  # immediately create children.

  def index
    @spaces = Space.all
  end

  def show
  end

  def edit
  end

  def update
    @space.update(space_params)
    redirect_to space_path(@space)
  end

  def destroy
    sc = Connection.where(space_id: @space.id).first
    sc.descendants.reverse.each do |descendant|
      descendant.space.destroy
    end
    @space.destroy
    redirect_to root_path #not perfect: should redirect to shelf
  end

  private

  def space_params
    params.require(:space).permit(:name, :description)
  end

  def set_space
    @space = Space.find(params[:id])
  end

end
