class AddCodeToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :code, :string
    add_index :countries, :code
  end
end
