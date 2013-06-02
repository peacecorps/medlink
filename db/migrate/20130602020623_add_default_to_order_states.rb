class AddDefaultToOrderStates < ActiveRecord::Migration
  def change
    change_column :orders, :confirmed, :boolean, default: false
    change_column :orders, :fulfilled, :boolean, default: false
  end
end
