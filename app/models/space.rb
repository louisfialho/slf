class Space < ApplicationRecord
  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :items
  has_many :connections
end
