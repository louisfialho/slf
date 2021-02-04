class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

has_many :shelves

after_create :create_shelf


def create_shelf
    shelf = Shelf.new(user_id: self.id)
    shelf.save
end

end
