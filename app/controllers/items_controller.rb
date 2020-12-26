class ItemsController < ApplicationController
before_action :set_item, only: [:show, :edit, :update, :destroy]

  def new
    @item = Item.new
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
    end
  end

  def create
    @item = Item.new(item_params)
    @item.save
    if params[:item][:shelf_id].present?
      @shelf = Shelf.find(params[:item][:shelf_id])
      @shelf.items << @item
      redirect_to item_path(@item, shelf_id: @shelf.id)
    elsif params[:item][:space_id].present?
      @space = Space.find(params[:item][:space_id])
      @space.items << @item
      redirect_to item_path(@item, space_id: @space.id)
    end
  end

  def index
    @items = Item.al
  end

  def show
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
    end
  end

  def edit
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
    end
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

  private

  def item_params
    params.require(:item).permit(:url, :medium, :name, :description, :rating)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end

