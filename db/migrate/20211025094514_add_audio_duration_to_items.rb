class AddAudioDurationToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :audio_duration, :string
  end
end
