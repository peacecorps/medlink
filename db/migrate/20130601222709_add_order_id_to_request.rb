class AddOrderIdToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :order_id, :integer
  end
end
