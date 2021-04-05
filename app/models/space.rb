class Space < ApplicationRecord
  #acts_as_list
  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :items
  has_many :connections, dependent: :destroy
  has_many :children, through: :connections

  before_create :set_position

  def set_position
    self.position = 1 if position.blank?
  end
end
