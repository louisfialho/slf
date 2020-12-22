class CreateJoinTableShelvesItems < ActiveRecord::Migration[6.0]
  def change
    create_join_table :shelves, :items do |t|
      # t.index [:shelf_id, :item_id]
      # t.index [:item_id, :shelf_id]
    end
  end
end
