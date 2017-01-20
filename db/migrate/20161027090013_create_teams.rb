class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :member_id
      t.string :purpose

      t.timestamps
    end
  end
end
