class AddTelegramInformationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :telegram_hash, :string
    add_column :users, :telegram_chat_id, :string
  end
end
