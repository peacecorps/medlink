class RemovePcHubFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :pc_hub_id
  end

  def down
    raise "Not Implemented"
  end
end
