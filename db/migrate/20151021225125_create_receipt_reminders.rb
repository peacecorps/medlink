class CreateReceiptReminders < ActiveRecord::Migration
  def change
    create_table :receipt_reminders do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :response, index: true, foreign_key: true
      t.belongs_to :message, index: true, foreign_key: true

      t.datetime :created_at, null: false
    end
  end
end
