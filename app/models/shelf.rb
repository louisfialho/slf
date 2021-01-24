class Shelf < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :items
  has_and_belongs_to_many :spaces
end
