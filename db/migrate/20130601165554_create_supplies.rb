class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :shortcode
      t.string :name

      t.timestamps
    end
    add_index :supplies, :shortcode
  end
end
