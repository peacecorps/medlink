class AddCountryToPcHub < ActiveRecord::Migration
  def change
    add_column :pc_hubs, :country_id, :integer
  end
end
