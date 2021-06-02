require File.expand_path('config/environment', __dir__)

User.all.each do |user|
  username = user.username
  shelf = user.shelves.first
  shelf.name = username
  shelf.save
  p 'done'
end
