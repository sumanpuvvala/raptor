class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :category_id
      t.integer :classification_id
      t.integer :team_id
      t.text :details

      t.timestamps
    end
  end
end
