class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  has_many :orders

  belongs_to :country
  before_save { self.country = user.country }

  default_scope { where(archived_at: nil) }

  def archive!
    update_attributes archived_at: Time.now
  end

  def sms_instructions
    base = "TODO: implement base_message"
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
