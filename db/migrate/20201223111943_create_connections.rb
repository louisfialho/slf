class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.references :space, null: false, foreign_key: true
      t.column :parent_id, :integer
      t.timestamps
    end
  end
end
