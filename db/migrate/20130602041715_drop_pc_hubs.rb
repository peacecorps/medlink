class DropPcHubs < ActiveRecord::Migration
  def up
    drop_table :pc_hubs
    remove_column :orders, :pc_hub_id
  end

  def down
    raise "Not Implemented"
  end
end
