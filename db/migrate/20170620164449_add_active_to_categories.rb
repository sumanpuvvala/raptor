class AddActiveToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :active, :boolean
  end
end
