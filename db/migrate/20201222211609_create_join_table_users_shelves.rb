class CreateJoinTableUsersShelves < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :shelves do |t|
      # t.index [:user_id, :shelf_id]
      # t.index [:shelf_id, :user_id]
    end
  end
end
