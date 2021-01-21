class ChangeDescriptionName < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :description, :notes
  end
end
