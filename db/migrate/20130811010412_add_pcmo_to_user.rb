class AddPcmoToUser < ActiveRecord::Migration
  def change
    add_column :users, :pcmo_id, :integer
  end
end
