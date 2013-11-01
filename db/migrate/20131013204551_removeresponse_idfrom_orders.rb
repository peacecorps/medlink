class RemoveresponseIdfromOrders < ActiveRecord::Migration
  def change
  	remove_column     :orders, :response_id
  	remove_column     :orders, :responded_at
  end
end
