class CreateUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :urls do |t|
      t.string :entity
      t.string :url
      t.string :url_type

      t.timestamps
    end
  end
end
