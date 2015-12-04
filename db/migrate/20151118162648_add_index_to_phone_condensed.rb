class AddIndexToPhoneCondensed < ActiveRecord::Migration
  def change
    change_column :phones, :condensed, :string, index: true, unique: true, null: false
  end
end
