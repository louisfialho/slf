class DropShelvesUsers < ActiveRecord::Migration[6.0]
  def change
    drop_table :shelves_users
  end
end
