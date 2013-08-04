class AbsorbRequestInToOrder < ActiveRecord::Migration
  def up
    add_column :orders, :supply_id, :integer
    add_column :orders, :dose, :string
    add_column :orders, :quantity, :integer

    drop_table :requests
  end

  def down
    raise "Not Implemented"
  end
end
