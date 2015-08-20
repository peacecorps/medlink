class AddCancelledAtToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :cancelled_at, :datetime
  end
end
