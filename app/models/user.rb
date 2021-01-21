class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

has_and_belongs_to_many :shelves

after_create do
    shelf = Shelf.new(name: 'default shelf')
    shelf.save
    User.last.shelves << shelf
end

end
