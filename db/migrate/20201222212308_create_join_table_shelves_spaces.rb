class CreateJoinTableShelvesSpaces < ActiveRecord::Migration[6.0]
  def change
    create_join_table :shelves, :spaces do |t|
      # t.index [:shelf_id, :space_id]
      # t.index [:space_id, :shelf_id]
    end
  end
end
