class TwilioAccount < ActiveRecord::Base
  has_many :messages, class_name: "SMS"

  validates :sid, presence: true, uniqueness: true

  def send_text to:, text:
    phone = Phone.for number: to
    UserTexter.new(phone: phone, twilio_account: self).send text
  end

  def client
    # :nocov:
    @_client ||= Twilio::REST::Client.new(sid, auth)
    # :nocov:
  end
end
