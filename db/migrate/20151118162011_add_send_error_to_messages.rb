class AddSendErrorToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :send_error, :text
  end
end
