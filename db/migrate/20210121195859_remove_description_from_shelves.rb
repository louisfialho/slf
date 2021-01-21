class RemoveDescriptionFromShelves < ActiveRecord::Migration[6.0]
  def change
    remove_column :shelves, :description
  end
end
