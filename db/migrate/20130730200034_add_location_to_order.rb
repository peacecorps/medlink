class AddLocationToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :location, :string
  end
end
