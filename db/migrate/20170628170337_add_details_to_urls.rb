class AddDetailsToUrls < ActiveRecord::Migration[5.0]
  def change
    add_column :urls, :details, :text
  end
end
