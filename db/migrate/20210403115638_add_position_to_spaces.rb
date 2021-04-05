class AddPositionToSpaces < ActiveRecord::Migration[6.0]
  def change
    add_column :spaces, :position, :integer
  end
end
