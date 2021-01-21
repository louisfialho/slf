class RemoveDescriptionFromSpaces < ActiveRecord::Migration[6.0]
  def change
    remove_column :spaces, :description
  end
end
