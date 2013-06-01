class CreatePcHubs < ActiveRecord::Migration
  def change
    create_table :pc_hubs do |t|
      t.string :name
      t.integer :country_id

      t.timestamps
    end
  end
end
