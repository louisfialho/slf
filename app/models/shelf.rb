class Shelf < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :items
  has_and_belongs_to_many :spaces
end
