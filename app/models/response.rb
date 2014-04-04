class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  # TODO: validate that user & all orders are from the same country?
  has_many :orders

  def sms_instructions
    base = Medlink.translate "base_sms_response"
    long = "#{base} #{extra_text}"
    if long.length > SMS::MAX_LENGTH
      "#{base} #{Medlink.translate 'sms_see_email'}"
    else
      long
    end
  end

  def send!
    ResponseSMSJob.enqueue id
    MailerJob.enqueue :fulfillment, id
  end
end
