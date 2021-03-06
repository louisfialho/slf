class ItemsController < ApplicationController
before_action :set_item, only: [:show, :edit, :update, :destroy]
before_action :set_shelf_space, only: [:new, :show, :edit]
skip_before_action :verify_authenticity_token


  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = Item.new(item_params)
    authorize @item
    respond_to do |format|
      if @item.valid?
        if params[:item][:shelf_id].present?
          @shelf = Shelf.find(params[:item][:shelf_id])
          @shelf.items << @item
          format.html do
            redirect_to item_path(@item, shelf_id: @shelf.id)
          end
        elsif params[:item][:space_id].present?
          @space = Space.find(params[:item][:space_id])
          @space.items << @item
          format.html do
            redirect_to item_path(@item, space_id: @space.id)
          end
        end
      else
        format.js { render 'shelves/show_updated_view' }
        format.json { head :ok }
      end
    end
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

