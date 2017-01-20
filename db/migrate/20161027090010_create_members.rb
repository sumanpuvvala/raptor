class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :name
      t.string :title
      t.string :stream
      t.string :manager
      t.boolean :is_lead

      t.timestamps
    end
  end
end
