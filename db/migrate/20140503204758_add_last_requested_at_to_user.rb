class AddLastRequestedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_requested_at, :datetime
  end
end
