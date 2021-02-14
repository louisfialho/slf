class ItemsController < ApplicationController
before_action :set_item, only: [:show, :edit, :update, :destroy]
before_action :set_shelf_space, only: [:new, :show, :edit]

  # def new
  #   @item = Item.new
  #   authorize @item
  # end

  def create
    @item = Item.new
    authorize @item
    @item.save(validate: false)
    if params[:shelf_id].present?
      redirect_to item_step_path(@item, 'url', shelf_id: params[:shelf_id])
    elsif params[:space_id].present?
      redirect_to item_step_path(@item, 'url', space_id: params[:space_id])
    end
    # if params[:item][:shelf_id].present?
    #   @shelf = Shelf.find(params[:item][:shelf_id])
    #   @shelf.items << @item
    #   redirect_to item_path(@item, shelf_id: @shelf.id)
    # elsif params[:item][:space_id].present?
    #   @space = Space.find(params[:item][:space_id])
    #   @space.items << @item
    #   redirect_to item_path(@item, space_id: @space.id)
    # end
  end

  def index
    @items = policy_scope(Item)
  end

  def show
  end

  def edit
  end

  def update
    @item.update(item_params)
    if params[:item][:shelf_id].present?
      @shelf = Shelf.find(params[:item][:shelf_id])
      redirect_to item_path(@item, shelf_id: @shelf.id)
    elsif params[:item][:space_id].present?
      @space = Space.find(params[:item][:space_id])
      redirect_to item_path(@item, space_id: @space.id)
    end
  end

  def destroy
    @item.destroy
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
      redirect_to shelf_path(@shelf)
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
      redirect_to space_path(@space)
    end
  end

  def move_to_space_list
    $spaces = []

    shelf = @current_user.shelves.first
    spaces_on_shelf = shelf.spaces

    for s in spaces_on_shelf do
      $spaces << s.name
      connections = s.connections
      recursive_space_search(connections)
    end

    return $spaces
  end

  def recursive_space_search(array_of_connections)
    for c in array_of_connections do
      $spaces << c.space.name
      if c.space.children.empty? == false
        children = c.space.children
        recursive_space_search(children)
      end
    end
  end

  helper_method :move_to_space_list

  private

  def item_params
    params.require(:item).permit(:url, :medium, :status, :name, :notes, :rank)
  end

  def set_item
    @item = Item.find(params[:id])
    authorize @item
  end

  def set_shelf_space
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
    end
  end
end

