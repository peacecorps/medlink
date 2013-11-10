class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :order_id
      t.string :delivery_method
      t.string :instructions

      t.timestamps
    end

    remove_column :orders, :delivery_method, :string
    remove_column :orders, :instructions,    :string
    remove_column :orders, :responded_at,    :datetime
    add_column    :orders, :response_id,     :integer
  end
end
