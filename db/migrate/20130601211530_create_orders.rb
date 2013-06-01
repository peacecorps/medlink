class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :pc_hub_id
      t.boolean :confirmed
      t.boolean :fulfilled
      t.string :phone
      t.string :email
      t.text :extra

      t.timestamps
    end
  end
end
