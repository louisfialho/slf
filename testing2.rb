require File.expand_path('config/environment', __dir__)

#mettre status de TOUS les items existants = not started

Item.all.each do |item|
  item.status = "finished"
end

User.all.reverse.each do |user|

  p user.id

  shelf = Shelf.find_by(username: user.username)

  # Créer espaces 'Not started' etc.
  space1 = Space.create(name: "Not started", position: 1)
  space2 = Space.create(name: "In progress", position: 2)
  space3 = Space.create(name: "Finished", position: 3)

  # Mettre tout ce qui est dans Added by Bot dans 'Not started'
  if shelf.spaces.where(name: '🤖 Added by Bot').first.nil? == false
    added_by_bot = shelf.spaces.where(name: '🤖 Added by Bot').first
    added_by_bot.items.each do |item|
      space1.items << item
      space1.save
      item.status = "not started"
    end

    spaces_in_added_by_bot = added_by_bot.children.map { |connection| connection.space }

    spaces_in_added_by_bot.each do |space|
      s1 = Connection.create(space: space1)
      co = s1.children.create(space: space)
    end

    added_by_bot.destroy
  end

  #items

  #spaces

  # mettre tout ce qui reste sur la shelf dans finished

  # Mettre tt ce qui reste sur la shelf dans 'Finished'
  shelf.items.each do |item|
    space3.items << item
    space3.save
    item.status = "finished"
  end

  # mettre aussi les spaces
  shelf.spaces.each do |space|
    s1 = Connection.create(space: space3)
    co = s1.children.create(space: space)
  end

  shelf.spaces << space1
  shelf.spaces << space2
  shelf.spaces << space3
  shelf.save

end
