class AddReplacementToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :replacement_id, :integer
    add_foreign_key :responses, :requests, column: :replacement_id
  end
end
