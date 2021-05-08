class AddNullFalseToFirstLastAndUserName < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :username, false
    change_column :users, :username, :string, :limit => 30
  end
end
