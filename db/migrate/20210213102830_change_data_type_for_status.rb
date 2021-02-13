class ChangeDataTypeForStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :items, :status, 'integer USING CAST(status AS integer)'
  end
end
