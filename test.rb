# on a un item
# on trouve son space
# si ce space est sur la shelf, on trouve la shelf immé
# si ce space est dans un space parent, on trouve ce space parent
# si ce space parent est sur la shelf, on trouve la shelf immé
# sinon, on trouve le space parent de ce space parent
# si le space parent de ce space parent est sur la shelf, on trouve la shelf immé
# ...
# on s'arrête quand on a trouvé la shelf

def shelf(item)
  @space = item.spaces.first
  if @space.shelves.empty? == false
    @shelf = @space.shelves.first
  else
    @shelf = recursive_parent_search(@space).shelves.first
  end
  return @shelf
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

p shelf(Item.find(21))
  # le space est dans un space parent
  # on trouve le space parent
  # on teste si le space parent a une shelf
  # sinon on recommence
