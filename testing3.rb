User.all.reverse.each do |user|
  shelf = Shelf.find_by(username: user.username)
  not_started = shelf.spaces.where(name: 'Not started').first
  not_started.items.each do |item|
    item.status = "not started"
    item.save(validate: false)
  end
end
