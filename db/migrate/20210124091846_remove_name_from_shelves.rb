class RemoveNameFromShelves < ActiveRecord::Migration[6.0]
  def change
    remove_column :shelves, :name, :string
  end
end
