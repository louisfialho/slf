# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# User.destroy_all
# puts 'Creating a user...'
# user = User.create(email: 'louis.fialho@hec.edu', password: '123456', password_confirmation: '123456')

# Shelf.destroy_all
# puts 'Creating shelves...'

# shelf_1 = Shelf.create(user: user)
# shelf_1.save!
# user.shelves << shelf_1

# shelf_2 = Shelf.create(user: user)
# shelf_2.save!
# user.shelves << shelf_2

# shelf_3 = Shelf.create(user: user)
# shelf_3.save!
# user.shelves << shelf_3

# Space.destroy_all
# puts 'Creating first level spaces...'

# space_1 = Space.create(name: 'Space 1')
# space_1.save!
# shelf_1.spaces << space_1
# space_1_c = Connection.create(space: space_1)

# space_2 = Space.create(name: 'Space 2')
# space_2.save!
# shelf_1.spaces << space_2
# space_2_c = Connection.create(space: space_2)

# space_3 = Space.create(name: 'Space 3')
# space_3.save!
# shelf_1.spaces << space_3
# space_3_c = Connection.create(space: space_3)

# Item.destroy_all
# puts 'Creating first level items...'

# item_1 = Item.create(url: 'url1', medium: 'book', name: 'item 1', notes: 'My item 1', rank: 'high', notes: "My item")
# item_1.save!
# shelf_1.items << item_1

# item_2 = Item.create(url: 'url2', medium: 'book', name: 'item 2', notes: 'My item 2', rank: 'high', notes: "My item")
# item_2.save!
# shelf_1.items << item_2

# item_3 = Item.create(url: 'url3', medium: 'book', name: 'item 3', notes: 'My item 3', rank: 'high', notes: "My item")
# item_3.save!
# shelf_1.items << item_3

# puts 'Creating second level spaces...'

# space_1_1 = Space.create(name: 'Space 11')
# space_1_1.save!
# space_1_1_c = space_1_c.children.create(space: space_1_1)

# space_1_2 = Space.create(name: 'Space 12')
# space_1_2.save!
# space_1_2_c = space_1_c.children.create(space: space_1_2)

# space_1_3 = Space.create(name: 'Space 13')
# space_1_3.save!
# space_1_3_c = space_1_c.children.create(space: space_1_3)

# puts 'Creating second level items...'

# item_1_1 = Item.create(url: 'url11', medium: 'book', name: 'item 11', status: "not started", rank: 'high', notes: "My item")
# item_1_1.save!
# space_1.items << item_1_1

# item_1_2 = Item.create(url: 'url12', medium: 'book', name: 'item 12', status: "not started", rank: 'high', notes: "My item")
# item_1_2.save!
# space_1.items << item_1_2

# item_1_3 = Item.create(url: 'url13', medium: 'book', name: 'item 13', status: "not started", rank: 'high', notes: "My item")
# item_1_3.save!
# space_1.items << item_1_3

# puts 'Creating third level spaces...'

# space_1_1_1 = Space.create(name: 'Space 111')
# space_1_1_1.save!
# space_1_1_1_c = space_1_1_c.children.create(space: space_1_1_1)

# space_1_1_2 = Space.create(name: 'Space 112')
# space_1_1_2.save!
# space_1_1_2_c = space_1_1_c.children.create(space: space_1_1_2)

# space_1_1_3 = Space.create(name: 'Space 113')
# space_1_1_3.save!
# space_1_1_3_c = space_1_1_c.children.create(space: space_1_1_3)

# puts 'Creating third level items...'

# item_1_1_1 = Item.create(url: 'url111', medium: 'book', name: 'item 111', status: "not started", rank: 'high', notes: "My item")
# item_1_1_1.save!
# space_1_1.items << item_1_1_1

# item_1_1_2 = Item.create(url: 'url112', medium: 'book', name: 'item 112', status: "not started", rank: 'high', notes: "My item")
# item_1_1_2.save!
# space_1_1.items << item_1_1_2

# item_1_1_3 = Item.create(url: 'url113', medium: 'book', name: 'item 113', status: "not started", rank: 'high', notes: "My item")
# item_1_1_3.save!
# space_1_1.items << item_1_1_3

# puts 'Finished!'


