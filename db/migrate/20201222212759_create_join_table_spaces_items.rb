class CreateJoinTableSpacesItems < ActiveRecord::Migration[6.0]
  def change
    create_join_table :spaces, :items do |t|
      # t.index [:space_id, :item_id]
      # t.index [:item_id, :space_id]
    end
  end
end
