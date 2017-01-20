class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.integer :course_id
      t.integer :member_id
      t.string :status
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
