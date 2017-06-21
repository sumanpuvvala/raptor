class AddActiveToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :active, :boolean
  end
end
