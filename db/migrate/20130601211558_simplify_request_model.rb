class SimplifyRequestModel < ActiveRecord::Migration
  def up
    [ :user_id, :location, :state, :phone, :email, :confirmed,
      :complete, :extra_text ].each do |col|
        remove_column :requests, col
    end
  end

  def down
    raise "Not implemented"
  end
end
