class ChangeColumnNameNotes < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :notes, :text_content
  end
end
