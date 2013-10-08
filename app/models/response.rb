class Response < ActiveRecord::Base
  belongs_to :order

  validates_presence_of :delivery_method, message: "is missing"
  validates :instructions, length: { maximum: 160 }

  def send!
    to = order.phone || order.user.phone
    SMSJob.enqueue(to, instructions) if to
    MailerJob.enqueue :fulfillment, id
  end
end

