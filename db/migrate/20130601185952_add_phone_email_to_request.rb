class AddPhoneEmailToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :phone, :string
    add_column :requests, :email, :string
  end
end
