class AddReceiptToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :received_at, :datetime
    add_column :orders, :flagged, :boolean, null: false, default: false
  end
end
