class Item < ApplicationRecord
  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces
end
