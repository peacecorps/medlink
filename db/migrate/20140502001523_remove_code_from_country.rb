class RemoveCodeFromCountry < ActiveRecord::Migration
  def change
    remove_column :countries, :code, :string
  end
end
