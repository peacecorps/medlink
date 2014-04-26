class AddDuplicatedAtToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :duplicated_at, :datetime
  end
end
