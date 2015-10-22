class ReceiptReminder < ActiveRecord::Base
  belongs_to :user
  belongs_to :response
  belongs_to :message, class_name: "SMS"

  validates_presence_of :user, :response, :message

  def self.latest
    order(created_at: :desc).first
  end
end
