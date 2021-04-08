class ItemsController < ApplicationController
before_action :set_item, only: [:show, :edit, :update, :destroy, :move]
before_action :set_shelf_space, only: [:new, :show, :edit, :move]
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
          @shelf.items.update_all('position = position + 1') # every new object has position 1 by default --> pushes all other positions to the right
          @shelf.spaces.update_all('position = position + 1')
          @shelf.items << @item
          format.html do
            redirect_to item_path(@item, shelf_id: @shelf.id)
          end
        elsif params[:item][:space_id].present?
          @space = Space.find(params[:item][:space_id])
          @space.items.update_all('position = position + 1') # every new space has position 1 by default --> pushes all other positions to the right
          # GET ALL SPACE CHILDREN OF THIS SPACE AND UPDATE THEIR POSTITION +1
          # space.children
          @space.children.each do |connection|
            connection.space.position += 1
            connection.space.save
          end
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
    position = @item.position
    @item.destroy
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
      # Tous les spaces et objets sur shelf avec index > index obj perdent 1
      @shelf.items.where('position > ?', position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.where('position > ?', position).update_all('position = position - 1')
      redirect_to shelf_path(@shelf)
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
      # Tous les spaces et objets sur space avec index > index obj perdent 1
      @space.items.where('position > ?', position).update_all('position = position - 1')
      @space.children.each do |connection|
        if connection.space.position > position
          connection.space.position = connection.space.position - 1
          connection.space.save
        end
      end
      redirect_to space_path(@space)
    end
  end

  def move_to_space
  # si on veut mettre item dans un space (faisable depuis un autre space ou depuis shelf)
    @item = Item.find(params[:item_id])
    authorize @item
    # setting item position to 1
    @item.position = 1
    @item.save(validate: false)
    @new_space = Space.find(params[:space_id])
    if @item.spaces.empty? == false   # si l'item est sur un space
      @item.spaces.destroy_all
    elsif @item.shelves.empty? == false # si l'item est sur une shelf
      @item.shelves.destroy_all
    end
    # finding all objects and spaces in the space and incrementing their position by one
    @new_space.items.update_all('position = position + 1')
    @new_space.children.each do |connection|
      connection.space.position += 1
      connection.space.save
    end
    @new_space.items << @item
    redirect_to item_path(@item, space_id: @new_space.id)
  end

  def move_to_shelf
    @item = Item.find(params[:item_id])
    authorize @item
    # setting item position to 1

    @space = @item.spaces.first

    @item.position = 1
    @item.save(validate: false)
    # @shelf = current_user.shelves.first marche pas

    if @space.shelves.empty? == false
       @shelf = @space.shelves.first
    else
    #   @shelf = recursive_parent_search(@space).shelves.first
      @space.connections.each do |connection|
        if connection.parent_id.nil? == false
            @connection = connection
        end
      end
      @shelf = @connection.root.space.shelves.first
    end

    @item.spaces.destroy_all
    # incrementing the position of all other objects and spaces on the shelf by +1
    @shelf.items.update_all('position = position + 1')
    @shelf.spaces.update_all('position = position + 1')
    @shelf.items << @item
    redirect_to item_path(@item, shelf_id: @shelf.id)
  end

  def move
    @item = Item.find(params[:id].to_i)
    current_position = @item.position
    new_position = params[:position].to_i

    if @item.shelves.empty? == false
      @shelf = @item.shelves.first
      objects = @shelf.items + @shelf.spaces # array of rails objects
    elsif @item.spaces.empty? == false
      @space = @item.spaces.first
      objects = @space.items + @space.children.map { |connection| connection.space }
    end

    objects.each do |object|
      if new_position < current_position
        if (object.position < current_position) && (object.position >= new_position)
          object.position = object.position + 1
          object.save(validate: false)
        end
      elsif new_position > current_position
        if (object.position > current_position) && (object.position <= new_position)
          object.position = object.position - 1
          object.save(validate: false)
        end
      end
    end
    @item.position = new_position
    @item.save(validate: false)
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

  # def recursive_parent_search(space)
  #   while @space.shelves.empty?
  #     @space.connections.each do |connection|
  #       if connection.parent_id.nil? == false
  #           @space = connection.parent.space
  #       end
  #     end
  #   end
  #   return @space
  # end
end

