class SpacesController < ApplicationController
before_action :set_space, only: [:show, :edit, :update, :destroy, :move]
skip_after_action :verify_authorized, only: [:space_name, :space_children]

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
      @shelf.items.update_all('position = position + 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.update_all('position = position + 1')
      @shelf.spaces << @space
      redirect_to shelf_path(@shelf)
    elsif params[:space][:parent_id].present?
      @child = Space.new(space_params)
      authorize @child, policy_class: SpacePolicy
      @child.save
      @parent = Space.find(params[:space][:parent_id])
      @parent.items.update_all('position = position + 1')
      @parent.children.each do |connection|
        connection.space.position += 1
        connection.space.save
      end
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
    @item = Item.new
    @child = Space.new
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
    position = @space.position
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
      @shelf.items.where('position > ?', position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.where('position > ?', position).update_all('position = position - 1')
      redirect_to shelf_path(@shelf)
    elsif params[:parent_id].present?
      @space = Space.find(params[:parent_id])
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

  def move_space_to_space
    @current_space = Space.find(params[:current_space_id])
    authorize @current_space
    @destination_space = Space.find(params[:destination_space_id])
    if @current_space.shelves.empty? == false
      @current_space.shelves.destroy_all # ASSUMES THAT A SPACE HAS ONLY ONE SHELF. ANOTHER SOLUTION WOULD BE TO DELETE THE SPACE ONLY FROM THE SHELF OF THE CURRENT USER.
    elsif @current_space.connections.nil? == false
      @current_space.connections.destroy_all
    end
    if !@destination_space.shelves.empty? && @destination_space.connections.empty? # si un space est sur une shelf, et n'est pas encore parent (i.e. n'a aucune connection)
      s1 = Connection.create(space: @destination_space)
      s1.children.create(space: @current_space)
    else
      @destination_space.connections.first.children.create(space: @current_space)
    end
    redirect_to space_path(@destination_space)
  end

  def move_space_to_shelf
    # on prend un space qui n'est PAS sur la shelf
    @space = Space.find(params[:current_space_id])
    # authorize @space

    # @shelf = recursive_parent_search2(@space).shelves.first
    # @space = Space.find(params[:current_space_id])

    # on trouve la shelf correspondante
    @shelf = current_user.shelves.first #ok
    # @shelf.items.update_all('position = position + 1')
    # @shelf.spaces.update_all('position = position + 1')

    # on supprime sa relation au space parent
    @space.connections.destroy_all #ok # ce space est forcément en dehors de la shelf (i.e. il a un space parent). here we assume that the space only has a connection with its parent. Are there cases where the space has connections other than the connection with its parent that shouldn't be deleted?
    # @space.position = 1 # setting space position to 1
    # @space.save

    # on ajoute le space à la shelf
    @shelf.spaces << @space #ok
    redirect_to shelf_path(@shelf)
  end

  def recursive_parent_search2(space)
    while @space.shelves.empty?
      @space.connections.each do |connection|
        if connection.parent_id.nil? == false
          @connection = connection
        end
      end
      @space = @connection.parent.space
    end
    return @space
  end

  def move
    @space = Space.find(params[:id].to_i)
    current_position = @space.position
    new_position = params[:position].to_i

    if @space.shelves.empty? == false
      @shelf = @space.shelves.first
      objects = @shelf.items + @shelf.spaces # array of rails objects
    else
      # si le @space n'est pas parent (.children.empty?), alors il a une seule connection qui indique son parent
      if @space.children.empty?
      # sélectionner le space parent
        @parent = @space.connections.first.parent.space
      else
      # si le @space est lui-même parent, alors il a une connection 'nil' pour indiquer qu'il est parent. il faut regarder toutes les connections et trouver celle qui mentionne son parent.
        @space.connections.each do |connection|
          if connection.parent_id.nil? == false
            @parent = connection.parent.space
          end
        end
      end
      # sélectionner tous les objets du space parent
      objects = @parent.items + @parent.children.map { |connection| connection.space }
    end

    objects.each do |object|
      if new_position < current_position
        if (object.position < current_position) && (object.position >= new_position)
          object.position += 1
          object.save(validate: false)
        end
      elsif new_position > current_position
        if (object.position > current_position) && (object.position <= new_position)
          object.position = object.position - 1
          object.save(validate: false)
        end
      end
    end

    @space.position = new_position
    @space.save
  end

  def space_name
    space_name = Space.find(params[:id]).name
    render json: {space_name: space_name}
  end

  def space_children
    space = Space.find(params[:id])
    space_children = space.children.map { |connection| connection.space }
    space_children = space_children.sort_by {|space| space.position}
    render json: {space_children: space_children}
  end

  private

  def space_params
    params.require(:space).permit(:name, :description)
  end

  def set_space
    @space = Space.find(params[:id])
    authorize @space
  end
end
