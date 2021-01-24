class AddUserToShelves < ActiveRecord::Migration[6.0]
  def change
    add_reference :shelves, :user, foreign_key: true
  end
end
