class ItemsController < ApplicationController
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
    @item = Item.find(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:url, :medium, :name, :description, :rating)
  end
end

