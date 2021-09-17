class RepositioningItemsAndSpacesJob < ApplicationJob
  queue_as :default

  def perform(shelf)
    shelf.items.update_all('position = position + 1') # every new object has position 1 by default --> pushes all other positions to the right
    shelf.spaces.update_all('position = position + 1')
  end
end
