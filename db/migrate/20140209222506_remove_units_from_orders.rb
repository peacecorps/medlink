class RemoveUnitsFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :dose, :string
    remove_column :orders, :quantity, :integer
  end
end
