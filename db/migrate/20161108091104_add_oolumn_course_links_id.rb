class AddOolumnCourseLinksId < ActiveRecord::Migration[5.0]
  def self.up
    change_table :course_links do |t|
      t.integer :id
    end
  end
end
