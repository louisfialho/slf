class RemoveStatusAndRankFromItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :status, :integer
  end
end
