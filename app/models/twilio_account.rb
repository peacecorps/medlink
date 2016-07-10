class TwilioAccount < ApplicationRecord
  has_many :messages, class_name: "SMS"

  validates :sid, presence: true, uniqueness: true

  def send_text to:, text:
    phone = Phone.for number: to
    UserTexter.new(phone: phone, twilio_account: self).send text
  end

  def client
    # :nocov:
    @_client ||= auth.present? && Twilio::REST::Client.new(sid, auth)
    # :nocov:
  end

  def self.null
    where(sid: "!!!", number: "+15555555555").first_or_create!
  end
end
