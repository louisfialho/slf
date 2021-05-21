require File.expand_path('config/environment', __dir__)
require 'csv'
file = "public/user_data.csv"
users = User.all
headers = ["email", "first_name", "last_name"]
CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
  users.each do |user|
  writer << [user.email, user.first_name, user.last_name]
  end
end
