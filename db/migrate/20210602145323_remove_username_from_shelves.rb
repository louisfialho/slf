class RemoveUsernameFromShelves < ActiveRecord::Migration[6.0]
  def change
    remove_column :shelves, :username, :string
  end
end
