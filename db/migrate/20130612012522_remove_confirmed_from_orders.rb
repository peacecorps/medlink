class RemoveConfirmedFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :confirmed
  end

  def down
    add_column :orders, :confirmed, :boolean
  end
end
