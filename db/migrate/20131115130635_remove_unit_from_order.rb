class RemoveUnitFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :unit, :string
  end
end
