class AddActiveToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :active, :boolean
  end
end
