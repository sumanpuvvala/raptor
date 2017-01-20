class CreateCourseLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :course_links, :id => false do |t|
      t.integer :course_id
      t.integer :child_course_id
      t.string :link_type

      t.timestamps
    end
  end
end
