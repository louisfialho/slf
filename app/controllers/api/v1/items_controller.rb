class Api::V1::ItemsController < Api::V1::BaseController
  def index
    @items = Item.first(10)
    render json: @items
  end

  def create
    # POST /api/v1/items # authenticated
    @item = Item.new(item_params)
    # get chrome_auth_token from headers
    chrome_auth_token = request.headers["HTTP_CHROME_AUTH_TOKEN"]
    @user = User.find_by(chrome_auth_token: chrome_auth_token)
    # authorize @item
    if @item.save
      # Add newly created item to 'Added by bot' for user
      @shelf = @user.shelves.first
      @not_started_space = @shelf.spaces.where(name: '🔴 Not started').first
      @not_started_space.items << @item
      item_url = "https://www.shelf.so/items/#{@item.id}?space_id=#{@not_started_space.id}"
      render json: {url: item_url}
    else
      render json: {
        error: "We cannot process this URL for now",
        status: 400
      }, status: 400
    end
  end

  private

  def item_params
    params.require(:item).permit(:url)
  end
end
