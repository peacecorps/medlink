class AddPcHubToUser < ActiveRecord::Migration
  def change
    add_column :users, :pc_hub_id, :integer
  end
end
