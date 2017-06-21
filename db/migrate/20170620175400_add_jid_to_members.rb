class AddJidToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :jid, :string
  end
end
