class CreateCountrySupplies < ActiveRecord::Migration
  def change
    create_table :country_supplies do |t|
      t.references :country, index: true
      t.references :supply, index: true

      t.timestamps
    end
  end
end
