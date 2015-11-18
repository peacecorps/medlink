class PreventNullMessagePhone < ActiveRecord::Migration
  def change
    change_column :messages, :phone_id, :integer, null: false
  end
end
