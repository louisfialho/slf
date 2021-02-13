class ChangeDataTypeForRank < ActiveRecord::Migration[6.0]
  def change
    change_column :items, :rank, 'integer USING CAST(rank AS integer)'
  end
end
