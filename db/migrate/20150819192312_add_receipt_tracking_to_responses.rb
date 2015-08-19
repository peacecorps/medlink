class AddReceiptTrackingToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :flagged, :boolean, default: false, null: false
    add_column :responses, :received_at, :datetime
    add_column :responses, :received_by, :integer
    add_foreign_key :responses, :users, column: :received_by
  end
end
