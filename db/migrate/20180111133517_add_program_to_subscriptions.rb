class AddProgramToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :program, :string
  end
end
