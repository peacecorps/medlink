class RemovePcmoIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :pcmo_id, :integer
  end
end
