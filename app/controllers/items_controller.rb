class ItemsController < ApplicationController
skip_before_action :authenticate_user!, :only => [:show, :create, :destroy, :move_to_shelf, :move_to_space, :update, :item_audio_duration, :was_item_added]
before_action :set_item, only: [:show, :edit, :update, :destroy, :move, :persist_mp3_url, :persist_audio_timestamp, :persist_audio_duration, :mark_as_finished]
before_action :set_shelf, only: [:show, :move_to_shelf]
before_action :set_shelf_space, only: [:new, :show, :edit, :move]
skip_before_action :verify_authenticity_token
skip_after_action :verify_authorized, only: [:item_audio_duration, :was_item_added]

  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = Item.new(item_params)
    authorize @item
    if @item.valid?
      # if params[:item][:shelf_id].present?
        # @shelf = Shelf.find(params[:item][:shelf_id])
        RepositioningItemsAndSpacesJob.perform_later(@shelf)
      if current_user
        @shelf = current_user.shelves.first
        @not_started_space = @shelf.spaces.where(name: 'Not started').first
        @not_started_space.items << @item
      end
        # format.html do
        #   redirect_to item_path(@item, shelf_id: @shelf.id)
        # end
      # elsif params[:item][:space_id].present?
      #   @space = Space.find(params[:item][:space_id])
      #   RepositioningInSpaceJob.perform_later(@space)
      #   @space.items << @item
      #   format.html do
      #     redirect_to item_path(@item, space_id: @space.id)
      #   end
      # end
      if current_user
        if current_user != User.first
          UserNotifierMailer.inform_louis_of_new_item(@item, current_user, 'app').deliver
        end
      end
    else
      format.js { render 'shelves/show_updated_view' }
      format.json { head :ok }
    end
  end

  def create_from_chrome_ext
    # parse POST request to set vars user_id and url
    # find user
    user = User.first # user = User.find(user_id)
    # create item based on url
    # add item to user's "Added by bot" space
  end

  def index
    @items = policy_scope(Item)
  end

  def show
    # @child = Space.new
    # @parent_id = Space.new
    @space = Space.new
    @shelf_mother = shelf_mother_of_item(@item)
    if current_user
      @user = current_user
      if @item.status == "not started"
        @item.status = "in progress"
        @shelf = @user.shelves.first
        @item.spaces.destroy_all
        @in_progress_space = @shelf.spaces.where(name: 'In progress').first
        @in_progress_space.items << @item
        @item.save
        #sassurer que si user go back, redirected vers in progress
      end
    end
    if @item.shelves.empty?
      @parent_space = @item.spaces.first
      @space = @item.spaces.first
    end
    # si shelf n'a qu'un item et 0 space OU shelf a un space added by bot qui a qu'un item
    if current_user
      if (@item.text_content.nil? == false) && ((@user.shelves.first.items.size == 1) && (@user.shelves.first.spaces.size == 1) && (@user.shelves.first.spaces.first.name == "🤖 Added by Bot") && (@user.shelves.first.spaces.first.items.empty?)) || (@user.shelves.first.items.empty? && (@user.shelves.first.spaces.size == 1) && (@user.shelves.first.spaces.first.name == "🤖 Added by Bot") && (@user.shelves.first.spaces.first.items.first.id == @item.id))
        flash.now[:notice] = "Congratulations on adding your first resource 🎉 You can listen to it for free by clicking on 'Options' in the top right and '👂 Listen'.".html_safe
      end
    end
    if params.has_key?(:origin)
      @space_back_id = params[:space_id]
    end
  end

  def edit
  end

  def update
    @item.assign_attributes(item_params)
    @item.save(validate: false)
    if params[:item][:shelf_id].present?
      @shelf = Shelf.find(params[:item][:shelf_id])
      redirect_to item_path(@item, shelf_id: @shelf.id)
    elsif params[:item][:space_id].present?
      @space = Space.find(params[:item][:space_id])
      redirect_to item_path(@item, space_id: @space.id)
    else
      redirect_to item_path(@item)
    end
  end

  def destroy
    position = @item.position
    if @item.spaces.empty? == false
      @space = @item.spaces.first
      # Tous les spaces et objets sur space avec index > index obj perdent 1
      @space.items.where('position > ?', position).update_all('position = position - 1')
      @space.children.each do |connection|
        if connection.space.position > position
          connection.space.position = connection.space.position - 1
          connection.space.save
        end
      end
      @item.destroy
      redirect_to space_path(@space)
    elsif @item.shelves.empty? == false
      @shelf = @item.shelves.first
      # Tous les spaces et objets sur shelf avec index > index obj perdent 1
      @shelf.items.where('position > ?', position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.where('position > ?', position).update_all('position = position - 1')
      @item.destroy
      redirect_to shelf_path(@shelf.username)
    end
  end

  def move_to_space
    @item = Item.find(params[:item_id])
    authorize @item
    position = @item.position

    if @item.spaces.empty? == false   # si l'item est sur un space
      # -1 to all spaces or objects AFTER the item on the initial space
      @initial_space = @item.spaces.first
      @initial_space.items.where('position > ?', position).update_all('position = position - 1')
      @initial_space.children.each do |connection|
        if connection.space.position > position
          connection.space.position = connection.space.position - 1
          connection.space.save
        end
      end
      @item.spaces.destroy_all
    elsif @item.shelves.empty? == false # si l'item est sur une shelf
      # -1 to all spaces or objects AFTER the item on the shelf
      @shelf = @item.shelves.first
      @shelf.items.where('position > ?', position).update_all('position = position - 1') # every new object has position 1 by default --> pushes all other positions to the right
      @shelf.spaces.where('position > ?', position).update_all('position = position - 1')
      @item.shelves.destroy_all
    end

    @item.position = 1
    @item.save(validate: false)

    @new_space = Space.find(params[:space_id])
    @new_space.items.update_all('position = position + 1')
    @new_space.children.each do |connection|
      connection.space.position += 1
      connection.space.save
    end
    @new_space.items << @item
    # redirect_to item_path(@item, space_id: @new_space.id)
    redirect_to space_path(@new_space)
  end

  def move_to_shelf
    @item = Item.find(params[:item_id])
    authorize @item

    # -1 to all spaces or objects AFTER the item on the initial space
    position = @item.position
    @initial_space = @item.spaces.first
    @initial_space.items.where('position > ?', position).update_all('position = position - 1')
    @initial_space.children.each do |connection|
      if connection.space.position > position
        connection.space.position = connection.space.position - 1
        connection.space.save
      end
    end

    @item.position = 1
    @item.save(validate: false)

    # @space = @item.spaces.first
    # if @space.shelves.empty? == false
    #   @shelf = @space.shelves.first
    # else
    #   @shelf = recursive_parent_search(@space).shelves.first
    # end

    # incrementing the position of all other objects and spaces on the shelf by +1
    @shelf = shelf_mother_of_item(@item)
    @shelf.items.update_all('position = position + 1')
    @shelf.spaces.update_all('position = position + 1')

    @item.spaces.destroy_all
    @shelf.items << @item
    #redirect_to item_path(@item, shelf_id: @shelf.id)
    redirect_to shelf_path(@shelf.username)
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

  def persist_mp3_url
    @item.mp3_url = params[:mp3_url]
    @item.save
    respond_to do |format|
    format.json { head :ok }
    end
  end

  def persist_audio_timestamp
    audio_timestamp = params[:audio_timestamp]
    @item.audio_timestamp = audio_timestamp
    @item.save
    respond_to do |format|
    format.json { head :ok }
    end
  end

  def persist_audio_duration
    @item.audio_duration = params[:audio_duration]
    @item.save
    respond_to do |format|
    format.json { head :ok }
    end
  end

  def item_audio_duration
    item = Item.find(params[:id])
    audio_duration = item.audio_duration
    render json: {audio_duration: audio_duration}
  end

  def mark_as_finished
    @item.status = "finished"
    @item.spaces.destroy_all
    if current_user
      @user = current_user
      @shelf = @user.shelves.first
      @finished_space = @shelf.spaces.where(name: 'Finished').first
      @finished_space.items << @item
      @item.save
    end
    respond_to do |format|
    format.json { head :ok }
    end
  end

  def was_item_added
    if current_user
      @user = current_user
      @shelf = current_user.shelves.first
      @not_started_space = @shelf.spaces.where(name: 'Not started').first
      @item = @not_started_space.items.find_by(url: params[:url].to_s)
      if (@item.nil? == false) && (@item.created_at > (Time.current - 5.minutes))
        render json: {response: "ok", space_id: @not_started_space.id, item_id: @item.id, item_medium: @item.medium, item_name: @item.name}
      end
    end
  end

  private

  def item_params
    params.require(:item).permit(:url, :medium, :status, :name, :text_content, :rank, :url_mp3, :audio_timestamp, :audio_duration)
  end

  def set_item
    @item = Item.find(params[:id])
    authorize @item
  end

  def set_shelf
    if user_signed_in?
      @shelf = current_user.shelves.first
    # else
    #   @shelf = shelf_mother_of_item(Item.find(params[:id]))
    end
  end

  def set_shelf_space
    if params[:shelf_id].present?
      @shelf = Shelf.find(params[:shelf_id])
    elsif params[:space_id].present?
      @space = Space.find(params[:space_id])
    end
  end

  def recursive_parent_search(space)
    while @space.shelves.empty?
      @space.connections.each do |connection|
        if connection.parent_id.nil? == false
            @space = connection.parent.space
        end
      end
    end
    return @space
  end
end

