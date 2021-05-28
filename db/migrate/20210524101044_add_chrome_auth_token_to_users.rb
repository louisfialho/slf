class AddChromeAuthTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :chrome_auth_token, :string
  end
end
