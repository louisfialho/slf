class RemoveRankFromItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :rank, :integer
  end
end
