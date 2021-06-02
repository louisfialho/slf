class AddNameToShelves < ActiveRecord::Migration[6.0]
  def change
    add_column :shelves, :name, :string
  end
end
