class Response < ActiveRecord::Base
  belongs_to :order

  def send!
    to = order.phone || order.user.phone
    SMSJob.enqueue(to, instructions) if to
    MailerJob.enqueue :fulfillment, id
  end
end

