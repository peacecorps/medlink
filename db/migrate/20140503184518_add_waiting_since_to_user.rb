class AddWaitingSinceToUser < ActiveRecord::Migration
  def change
    add_column :users, :waiting_since, :datetime
  end
end
