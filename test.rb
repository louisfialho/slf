require File.expand_path('config/environment', __dir__)

  def shelf_mother_of_item(item)
    if item.shelves.empty? == false
      item.shelves.first
    elsif item.spaces.empty? == false
      recursive_parent_search3(item.spaces.first).shelves.first
    end
  end

  def recursive_parent_search3(space)
    while space.shelves.empty?
      space.connections.each do |connection|
        if connection.parent_id.nil? == false
          @connection = connection
        end
      end
      space = @connection.parent.space
    end
    return space
  end

Item.where("url LIKE ?", "%twitter.com%").each do |tweet|
  if shelf_mother_of_item(tweet).user != User.first
    p tweet, shelf_mother_of_item(tweet).user.id
  end
end
