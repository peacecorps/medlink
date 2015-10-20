class AddSendErrorToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :send_error, :string
  end
end
