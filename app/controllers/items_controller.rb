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
      redirect_to item_path(@item)
    end
  end

  def index
    @items = Item.al
  end

  def show
  end

  def edit
  end

  def update
    @item.update(item_params)
    redirect_to item_path(@item)
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private

  def item_params
    params.require(:item).permit(:url, :medium, :name, :description, :rating)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end

