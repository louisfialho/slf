class ItemsController < ApplicationController
before_action :set_item, only: [:show, :edit, :update, :destroy]

  def new
    if params[:shelf_id].present?
      @item = Item.new
      @shelf = Shelf.find(params[:shelf_id])
    end
  end

  def create
    if params[:item][:shelf_id].present?
      @item = Item.new(item_params)
      @item.save
      @shelf = Shelf.find(params[:item][:shelf_id])
      @shelf.items << @item
      redirect_to item_path(@item, shelf_id: @shelf.id)
    end
  end

  def index
    @items = Item.al
  end

  def show
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    end
  end

  def edit
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    end
  end

  def update
    @item.update(item_params)
    @shelf = Shelf.find(params[:item][:shelf_id])
    redirect_to item_path(@item, shelf_id: @shelf.id)
  end

  def destroy
    @item.destroy
    @shelf = Shelf.find(params[:shelf_id])
    redirect_to shelf_path(@shelf)
  end

  private

  def item_params
    params.require(:item).permit(:url, :medium, :name, :description, :rating)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end

