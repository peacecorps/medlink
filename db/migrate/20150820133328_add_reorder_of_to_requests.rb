class AddReorderOfToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :reorder_of_id, :integer
    add_foreign_key :requests, :responses, column: :reorder_of_id
  end
end
