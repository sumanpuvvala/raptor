class AddEntityIdToUrls < ActiveRecord::Migration[5.0]
  def change
    add_column :urls, :entity_id, :number
  end
end
