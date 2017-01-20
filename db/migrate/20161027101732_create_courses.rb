class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :details
      t.integer :topic_id
      t.string :course_type
      t.string :time_estimate
      t.string :difficulty
      t.string :cost_course
      t.string :cost_certification
      t.string :member_id
      t.integer :credits
      t.string :university
      t.string :url

      t.timestamps
    end
  end
end
