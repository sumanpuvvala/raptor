class AddActiveToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :active, :boolean
  end
end
