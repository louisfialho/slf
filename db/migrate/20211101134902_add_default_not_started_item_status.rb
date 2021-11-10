class AddDefaultNotStartedItemStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :items, :status, :string, :default => 'not started'
  end
end
