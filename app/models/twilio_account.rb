class TwilioAccount < ActiveRecord::Base
  has_many :messages, class_name: "SMS"

  def self.default
    where(
      sid:    ENV.fetch('TWILIO_ACCOUNT_SID'),
      auth:   ENV.fetch('TWILIO_AUTH'),
      number: ENV.fetch('TWILIO_PHONE_NUMBER')
    ).first_or_create!
  end

  def client
    @_client ||= Twilio::REST::Client.new sid, auth
  end

  def send_text to, text
    user = User.find_by_phone_number to

    sms = messages.create!(
      user:      user,
      number:    to,
      text:      text,
      direction: :outgoing
    )

    client.account.sms.messages.create(
      from: number,
      to:   Phone.condense(to),
      body: text
    )

    sms
  end
end
