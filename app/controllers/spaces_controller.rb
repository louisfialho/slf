class SpacesController < ApplicationController
skip_before_action :authenticate_user!, :only => [:show]
before_action :set_space, only: [:show, :edit, :update, :destroy, :move]
before_action :set_shelf, only: [:create, :add_item_to, :show, :destroy, :move_space_to_space, :move_space_to_shelf, :move]
skip_after_action :verify_authorized, only: [:space_name, :space_children]
skip_before_action :verify_authenticity_token # vulnerability?

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
      if params[:space][:item_id]
        add_item_to(@space)
        redirect_to space_path(@space)
      elsif params[:space][:space_id]
        # space est déjà créé dans shelf. il faut juste ajouter le space child dans space.
        # trouver child
        @child = Space.find(params[:space][:space_id])
        # trouver sa position
        child_position = @child.position
        @child.connections.each do |connection|
          if connection.parent_id.nil? == false
            @initial_space = connection.parent.space
          end
        end
        # si child est dans un space initial_space
        if @child.shelves.empty?
          # créer nvelle connection de child à space
          s1 = Connection.create(space: @space)
          co = s1.children.create(space: @child)
          # si child a des enfants
          if @child.children.empty? == false
            # rediriger toutes les co avec les enfants de child vers cette nvelle co
            @child.children.each do |connection|
              connection.parent_id = co.id
              connection.save
            end
          end
          # supprimer la co de child à initial_space
          @child.connections.each do |connection|
            if (connection.parent.nil? == false) && (connection.parent.space == @initial_space)
              connection.destroy
            end
          end
          # mettre -1 à ts les objets et spaces après child dans initial_space
          @initial_space.items.where('position > ?', child_position).update_all('position = position - 1')
          @initial_space.children.each do |connection|
            if connection.space.position > child_position
              connection.space.position = connection.space.position - 1
              connection.space.save
            end
          end
        # si child est sur la shelf // ca n'a pas trop de sens de le mettre dans un nv space sur la shelf...
        else
          # rompre co avec la shelf
          @child.shelves.destroy_all
          # créer la connection à space
          s1 = Connection.create(space: @space)
          co = s1.children.create(space: @child)
          # mettre -1 à ts les éléments après lui sur la shelf
          @shelf.items.where('position > ?', grand_child_position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
          @shelf.spaces.where('position > ?', grand_child_position).update_all('position = position - 1')
          # vérif que ca tient s'il a des enfants
        end
        redirect_to space_path(@space)
      else
        redirect_to shelf_path(@shelf)
      end
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
      if params[:space][:item_id]
        add_item_to(@child)
        redirect_to space_path(@child)
      elsif params[:space][:space_id]
        # child (nouveau space créé) est déjà dans parent. goal: mettre grand_child dans child
        # trouver grand_child
        @grand_child = Space.find(params[:space][:space_id])
        # trouver sa position
        grand_child_position = @grand_child.position
        # si grand_child est sur la shelf
        if @grand_child.shelves.empty? == false
          # copier code pr trouver la shelf, mettre -1 à ts les objets et spaces, détruire co
          @shelf.items.where('position > ?', grand_child_position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
          @shelf.spaces.where('position > ?', grand_child_position).update_all('position = position - 1')
          @grand_child.shelves.destroy_all
          if !@child.shelves.empty? && @child.connections.empty? # si un space est sur une shelf, et n'est pas encore parent (i.e. n'a aucune connection)
            s1 = Connection.create(space: @child)
            s1.children.create(space: @grand_child)
          else
            @child.connections.first.children.create(space: @grand_child)
          end
        # si grand_child est dans un space: initial_space
        else # elsif...)
          # trouver ce space initial_space
          @grand_child.connections.each do |connection|
            if connection.parent_id.nil? == false
              @initial_space = connection.parent.space
            end
          end
          # mettre -1 à ts les objets et spaces dans @initial_space
          @initial_space.items.where('position > ?', grand_child_position).update_all('position = position - 1')
          @initial_space.children.each do |connection|
            if connection.space.position > grand_child_position
              connection.space.position = connection.space.position - 1
              connection.space.save
            end
          end
          # si grand child has children
          if @grand_child.children.empty? == false
            # d'abord créer la co de grand child à child
            parent_connection = nil
            @child.connections.each do |connection|
              if connection.parent_id == nil
                parent_connection = connection
              end
            end
            if parent_connection
              co = parent_connection.children.create(space: @grand_child)
            else
              # recréer connection ou destination space est parent
              s1 = Connection.create(space: @child)
              co = s1.children.create(space: @grand_child)
            end
            # pour chaque child de grand child, mettre à jour la co
            @grand_child.children.each do |connection|
              connection.parent_id = co.id
              connection.save
            end
            # suppr la co de grand child à initial space
            @grand_child.connections.each do |connection|
              if (connection.parent.nil? == false) && (connection.parent.space == @initial_space)
                connection.destroy
              end
            end
          # sinon
          else
            # destroy all connections
            @grand_child.connections.destroy_all
            # créer co grand child à child
            if !@child.shelves.empty? && @child.connections.empty? # si un space est sur une shelf, et n'est pas encore parent (i.e. n'a aucune connection)
              s1 = Connection.create(space: @child)
              s1.children.create(space: @grand_child)
            else
              @child.children.create(space: @grand_child)
            end
          end
        end
        # mettre pos 1 à grand_child, save
        @grand_child.position = 1
        @grand_child.save
        redirect_to space_path(@child)
      else
        redirect_to space_path(@parent)
      end
    end
  end

  def add_item_to(space)
    @item = Item.find(params[:space][:item_id])
    item_position = @item.position
    if @item.shelves.empty? == false
      @shelf.items.where('position > ?', item_position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.where('position > ?', item_position).update_all('position = position - 1')
      @item.shelves.destroy_all
    else
      @initial_space = @item.spaces.first
      @initial_space.items.where('position > ?', item_position).update_all('position = position - 1')
      @initial_space.children.each do |connection|
        if connection.space.position > item_position
          connection.space.position = connection.space.position - 1
          connection.space.save
        end
      end
      @item.spaces.destroy_all
    end
    @item.position = 1
    @item.save(validate: false)
    space.items << @item
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
    @space.connections.each do |connection|
      if connection.parent_id.nil? == false
        @parent = connection.parent.space
      end
    end
    if @space.shelves.empty? == false
      @shelf_mother = @space.shelves.first
    else
      @shelf_mother = recursive_parent_search3(@space).shelves.first
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
    # soit current space est dans shelf --> vers dest space. soit current space est dans parent space --> vers dest space
    @current_space = Space.find(params[:current_space_id])
    authorize @current_space

    position = @current_space.position

    @destination_space = Space.find(params[:destination_space_id])

    if @current_space.shelves.empty? == false
    # si sur shelf, trouver shelf, mettre -1 à ts les objets ou spaces après position dans shelf
      @shelf = @current_space.shelves.first
      @shelf.items.where('position > ?', position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.where('position > ?', position).update_all('position = position - 1')
      @current_space.shelves.destroy_all
      if !@destination_space.shelves.empty? && @destination_space.connections.empty? # si un space est sur une shelf, et n'est pas encore parent (i.e. n'a aucune connection)
        s1 = Connection.create(space: @destination_space)
        s1.children.create(space: @current_space)
      else
        @destination_space.connections.first.children.create(space: @current_space)
      end
    elsif @current_space.connections.nil? == false
    # si sur space, trouver space parent, mettre -1 à ts les objets ou spaces après position dans space PARENT
      @current_space.connections.each do |connection|
        if connection.parent_id.nil? == false
          @parent = connection.parent.space
        end
      end
      @parent.items.where('position > ?', position).update_all('position = position - 1')
      @parent.children.each do |connection|
        if connection.space.position > position
          connection.space.position = connection.space.position - 1
          connection.space.save
        end
      end

      if @current_space.children.empty? == false
      # Si @current_space a des enfants.
      # Si dans la co qui lie les enfants de @current_space à @current_space, le parent n'est pas une co ou @current_space est parent
      # Je crée d'abord une nouvelle connection entre @current_space et @destination_space
        # si @destination_space a déjà une co ou il est parent, j'utilise directement cette co et lui ajoute une co enfant (hi.connections.first.children.create(space: eship)))
        parent_connection = nil
        @destination_space.connections.each do |connection|
          if connection.parent_id == nil
            parent_connection = connection
          end
        end
        if parent_connection
          co = parent_connection.children.create(space: @current_space)
        else
          # recréer connection ou destination space est parent
          s1 = Connection.create(space: @destination_space)
          co = s1.children.create(space: @current_space)
        end
      # Ensuite, pour chaque enfant de @current_space, je définis c la connection de enfant à la co de current space et remplace la valeur de parent_id par la connection si dessus, puis c.save
        @current_space.children.each do |connection|
          connection.parent_id = co.id
          connection.save
        end
      # Enfin, je suppr la connection de @current_space à @parent.
        @current_space.connections.each do |connection|
          if (connection.parent.nil? == false) && (connection.parent.space == @parent)
            connection.destroy
          end
        end
      else
        @current_space.connections.destroy_all
        if !@destination_space.shelves.empty? && @destination_space.connections.empty? # si un space est sur une shelf, et n'est pas encore parent (i.e. n'a aucune connection)
          s1 = Connection.create(space: @destination_space)
          s1.children.create(space: @current_space)
        else
          @destination_space.connections.first.children.create(space: @current_space)
        end
      end
    end

    # mettre +1 à ts les objets ou spaces dans destination space
    @destination_space.items.update_all('position = position + 1')
    @destination_space.children.each do |connection|
      connection.space.position += 1
      connection.space.save
    end

    # mettre position = 1 à space et save
    @current_space.position = 1
    @current_space.save

    redirect_to space_path(@destination_space)
  end

  def move_space_to_shelf
    @space = Space.find(params[:current_space_id])
    authorize @space

    # trouver space parent et mettre -1 à ts les objets et spaces après position
    position = @space.position
    @space.connections.each do |connection|
      if connection.parent_id.nil? == false
        @parent = connection.parent.space
      end
    end
    @parent.items.where('position > ?', position).update_all('position = position - 1')
    @parent.children.each do |connection|
      if connection.space.position > position
        connection.space.position = connection.space.position - 1
        connection.space.save
      end
    end

    # on trouve la shelf correspondante
    @shelf.items.update_all('position = position + 1')
    @shelf.spaces.update_all('position = position + 1')

    # on supprime sa relation au space parent
    @space.connections.destroy_all
    @space.position = 1
    @space.save

    @shelf.spaces << @space
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

  def set_shelf
    if user_signed_in?
      @shelf = current_user.shelves.first
    end
  end
end
