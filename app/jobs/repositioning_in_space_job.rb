class RepositioningInSpaceJob < ApplicationJob
  queue_as :default

  def perform(space)
    space.items.update_all('position = position + 1') # every new space has position 1 by default --> pushes all other positions to the right
    # GET ALL SPACE CHILDREN OF THIS SPACE AND UPDATE THEIR POSTITION +1
    space.children.each do |connection|
      connection.space.position += 1
      connection.space.save
    end
  end
end
