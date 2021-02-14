# require File.expand_path('config/environment', __dir__)


# def move_to_space_list
#   $spaces = []

#   shelf = @current_user.shelves.first
#   spaces_on_shelf = shelf.spaces

#   for s in spaces_on_shelf do
#     connections = s.connections
#     recursive_space_search(connections)
#   end

#   return $spaces
# end

# def recursive_space_search(array_of_connections)
#   for c in array_of_connections do
#     $spaces << c.space.name
#     if c.space.children.empty? == false
#       children = c.space.children
#       recursive_space_search(children)
#     end
#   end
# end

# p move_to_space_list

