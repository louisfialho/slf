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

    shelf = current_user.shelves.first
    spaces_on_shelf = shelf.spaces #this can be changed using order by, for instance to display most popular spaces!

    for s in spaces_on_shelf do
      if s.connections.empty? == false
        connections = s.connections
        recursive_space_search(connections)
      else
        $spaces << s
      end
    end

    return $spaces
  end

  def recursive_space_search(array_of_connections)
    for c in array_of_connections do
      $spaces << c.space
      if c.space.children.empty? == false
        children = c.space.children
        recursive_space_search(children)
      end
    end
  end

  def move_to_space
  # si on veut mettre item dans un space (faisable depuis un autre space ou depuis shelf)
    @item = Item.find(params[:item_id])
    authorize @item
    @new_space = Space.find(params[:space_id])
    if @item.spaces.empty? == false   # si l'item est sur un space
      @item.spaces.destroy_all
    elsif @item.shelves.empty? == false # si l'item est sur une shelf
      @item.shelves.destroy_all
    end
    @new_space.items << @item
    redirect_to item_path(@item, space_id: @new_space.id)
  end

  def move_to_shelf
    @item = Item.find(params[:item_id])
    authorize @item
    @shelf = current_user.shelves.first
    @item.spaces.destroy_all
    @shelf.items << @item
    redirect_to item_path(@item, shelf_id: @shelf.id)
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

