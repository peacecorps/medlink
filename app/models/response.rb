class Response < ActiveRecord::Base
  belongs_to :order

  validates_presence_of :delivery_method, message: "is missing"
  validates :instructions, length: { maximum: 160 },
    format: { :with => /\A[a-zA-Z0-9\.\/ ]*\z/,
    :message => "- Please replace the [placeholders] with values." }

  def send!
    to = order.phone || order.user.phone
    SMSJob.enqueue(to, instructions) if to
    MailerJob.enqueue :fulfillment, id
  end
end

