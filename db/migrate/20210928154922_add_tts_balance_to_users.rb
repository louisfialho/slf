class AddTtsBalanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tts_balance_in_min, :string
  end
end
