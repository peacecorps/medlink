class AddTrackingToOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :fulfilled, :boolean
    add_column :orders, :fulfilled_at, :date
    add_column :orders, :received_at, :date
  end
end
