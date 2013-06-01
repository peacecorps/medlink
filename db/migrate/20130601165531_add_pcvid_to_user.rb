class AddPcvidToUser < ActiveRecord::Migration
  def change
    add_column :users, :pcv_id, :integer
  end
end
