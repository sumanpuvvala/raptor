class AlterColumnCoursesCredits < ActiveRecord::Migration[5.0]
  def self.up
    change_table :courses do |t|
      t.change :credits, :decimal, :precision => 10, :scale => 2
    end
  end
  def self.down
    change_table :courses do |t|
      t.change :credits, :integer
    end
  end
end
