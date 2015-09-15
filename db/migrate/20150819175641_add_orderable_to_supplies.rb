class AddOrderableToSupplies < ActiveRecord::Migration
  def change
    add_column :supplies, :orderable, :boolean, :default => true
  end
end
