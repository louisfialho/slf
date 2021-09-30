class ChangeMinutesToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :tts_balance_in_min, :float, using: 'tts_balance_in_min::double precision', :default => nil
  end
end
