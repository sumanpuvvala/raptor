class AddDueToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :due, :date
  end
end
