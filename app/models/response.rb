class Response < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :message

  has_many :orders

  default_scope { where(archived_at: nil) }

  def archive!
    update_attributes archived_at: Time.now
  end

  def sms_instructions
    base = "TODO: implement base_message"
    long = "#{base} #{extra_text}"
    if long.length > SMS::MAX_LENGTH
      "#{base} #{I18n.t! 'sms_see_email'}"
    else
      long
    end
  end

  def send!
    ResponseSMSJob.enqueue id
    MailerJob.enqueue :fulfillment, id
  end
end
