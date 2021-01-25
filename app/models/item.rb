class Item < ApplicationRecord
  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces
  MEDIUM = ['book', 'podcast', 'video', 'web', 'other']
  STATUS = ['not sarted', 'in progress', 'finished']
  RANK = ['low', 'medium', 'high']
end
