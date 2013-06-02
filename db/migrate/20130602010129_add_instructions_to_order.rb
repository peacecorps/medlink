class AddInstructionsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :instructions, :string
  end
end
