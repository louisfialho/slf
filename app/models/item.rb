class Item < ApplicationRecord
  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces

  before_validation :ensure_item_has_a_name

  MEDIUM = ['book', 'podcast', 'video', 'web', 'other']
  STATUS = ['not sarted', 'in progress', 'finished']
  RANK = ['low', 'medium', 'high']

  cattr_accessor :form_steps do
    %w(url medium name status rank notes) #can now be accessed using Item.form_steps.
  end

  attr_accessor :form_step

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?

    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end

  validates :url, presence: true,
      if: -> { required_for_step?(:url) }
  validates :medium, presence: true,
      if: -> { required_for_step?(:medium) }
  validates :name, presence: true,
      if: -> { required_for_step?(:name) }

  def ensure_item_has_a_name
      if name.empty?
        self.name = "No name found"
      end
  end
end
