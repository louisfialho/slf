class Connection < ApplicationRecord
  belongs_to :space
  acts_as_tree order: "name"
end
