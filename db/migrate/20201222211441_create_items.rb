class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :url
      t.string :medium
      t.string :name
      t.string :description
      t.string :rating

      t.timestamps
    end
  end
end
