class AdddeliveryMethodtoorders < ActiveRecord::Migration
  def change
      add_column :orders, :responded_at,    :datetime
      add_column :orders, :delivery_method, :string
      add_column :orders, :entered_by,      :string
  end
end
