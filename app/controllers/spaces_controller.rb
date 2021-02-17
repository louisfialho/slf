class SpacesController < ApplicationController
before_action :set_space, only: [:show, :edit, :update, :destroy]

  def new
    if params[:shelf_id].present?
      @space = Space.new
      authorize @space
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:parent_id].present?
      @parent = Space.find(params[:parent_id])
      @child = Space.new
      authorize @child
    end
  end

  def create
    if params[:space][:shelf_id].present?
      @space = Space.new(space_params)
      authorize @space
      @space.save
      @shelf = Shelf.find(params[:space][:shelf_id])
      @shelf.spaces << @space
      redirect_to shelf_path(@shelf)
    elsif params[:space][:parent_id].present?
      @child = Space.new(space_params)
      authorize @child, policy_class: SpacePolicy
      @child.save
      @parent = Space.find(params[:space][:parent_id])
      if !@parent.shelves.empty? && @parent.connections.empty?
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
    @spaces = policy_scope(Space)
  end

  def show
    if @space.connections.empty? == false && @space.connections.first.parent_id.nil? == false
      @parent = Space.find(Connection.find(@space.connections.first.parent_id).space_id)
    end
  end

  def edit
  end

  def update
    @space.update(space_params)
    redirect_to space_path(@space)
  end

  def destroy
    ids = []
    ids << @space.id
    if !@space.connections.empty?
      sc = Connection.where(space_id: @space.id).first
      if !sc.descendants.empty?
        sc.descendants.reverse.each do |descendant|
          ids << descendant.space.id # a refactorer car la même méthode est dans le controller shelves. Faire methode privée ou ajouter à Application controller
         end
      end
    end
    Space.where(id: ids).destroy_all
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
      redirect_to shelf_path(@shelf)
    elsif params[:parent_id].present?
      @space = Space.find(params[:parent_id])
      redirect_to space_path(@space)
    end
  end

  def move_space_to_space
    @current_space = Space.find(params[:current_space_id])
    authorize @current_space
    @destination_space = Space.find(params[:destination_space_id])
    if @current_space.shelves.empty? == false
      @current_space.shelves.destroy_all # ASSUMES THAT A SPACE HAS ONLY ONE SHELF. ANOTHER SOLUTION WOULD BE TO DELETE THE SPACE ONLY FROM THE SHELF OF THE CURRENT USER.
    elsif @current_space.connections.nil? == false
      @current_space.connections.destroy_all
    end
    @destination_space.connections.first.children.create(space: @current_space)
    redirect_to space_path(@destination_space)
  end

  # def move_space_to_shelf
  #   current_space = Space.find(current_space_id)
  #   # ce space est forcément en dehors de la shelf (i.e. il a un space parent)
  #   # je trouve le space parent et je le suppr
  #   # je trouve la shelf du current user et j'ajoute current_space
  # end



  private

  def space_params
    params.require(:space).permit(:name, :description)
  end

  def set_space
    @space = Space.find(params[:id])
    authorize @space
  end
end
