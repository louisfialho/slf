class AddMp3UrlToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :mp3_url, :string
  end
end
