class AddAudioTimestampToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :audio_timestamp, :string
  end
end
