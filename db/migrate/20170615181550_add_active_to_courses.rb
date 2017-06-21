class AddActiveToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :active, :boolean
  end
end
