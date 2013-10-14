class Response < ActiveRecord::Base
  belongs_to :order

  validates_presence_of :delivery_method, message: "is missing"
  validates :instructions, format: { :with => /\A[^\[\]]*\z/,
    :message => "- Please replace the [placeholders] with values." },
    length: { maximum: 160 }
#/\A[a-zA-Z0-9\.\/ ]*\z/,

  def send!
    to = order.phone || order.user.phone
    SMSJob.enqueue(to, instructions) if to
    MailerJob.enqueue :fulfillment, id
  end
end

