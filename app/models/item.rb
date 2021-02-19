class Item < ApplicationRecord
  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces

  MEDIUM = ['book', 'podcast', 'video', 'web', 'other']
  STATUS = [1, 2, 3] # 1 = not started
  RANK = [1, 2, 3] # 1 = high prio

  validates :url, presence: true, url: true # see custom class
  validates :rank, :inclusion => 1..3, allow_nil: true
  validates :status, :inclusion => 1..3, allow_nil: true

  # def set_item_parameters
  #   self.name = "no name" if name.blank?
  #   self.medium = "other" if medium.blank?
  #   self.status = 1 if status.blank?
  #   self.rank = 2 if rank.blank?
  # end
end
