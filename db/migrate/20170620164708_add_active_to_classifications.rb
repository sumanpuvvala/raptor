class AddActiveToClassifications < ActiveRecord::Migration[5.0]
  def change
    add_column :classifications, :active, :boolean
  end
end
