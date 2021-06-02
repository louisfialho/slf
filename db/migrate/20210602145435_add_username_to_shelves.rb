class AddUsernameToShelves < ActiveRecord::Migration[6.0]
  def change
    add_column :shelves, :username, :string
  end
end
