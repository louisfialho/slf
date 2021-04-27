require File.expand_path('config/environment', __dir__)

def recursive_parent_search2(space)
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

p recursive_parent_search2(Space.find(218))
