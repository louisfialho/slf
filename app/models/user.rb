class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

has_many :shelves

after_create do
    user = User.last
    shelf = Shelf.new(user_id: user.id)
    shelf.save
end

end
