class AddPhoneToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :phone, index: true, foreign_key: true
  end
end
