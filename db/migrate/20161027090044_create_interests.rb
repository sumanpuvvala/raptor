class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.integer :topic_id
      t.integer :member_id

      t.timestamps
    end
  end
end
