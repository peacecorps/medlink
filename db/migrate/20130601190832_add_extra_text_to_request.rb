class AddExtraTextToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :extra_text, :string
  end
end
