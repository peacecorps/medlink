class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.integer :supply_id
      t.string :dose
      t.integer :quantity
      t.string :location
      t.string :state

      t.timestamps
    end
  end
end
