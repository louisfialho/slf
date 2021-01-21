class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :rating, :rank
  end
end
