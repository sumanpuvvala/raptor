class CreateNamedLists < ActiveRecord::Migration[5.0]
  def change
    create_table :named_lists do |t|
      t.string :list_name
      t.string :entry_name

      t.timestamps
    end
  end
end
