class AddNameToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :name, :string
  end
end
