class AddUnitToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :unit, :string
  end
end
