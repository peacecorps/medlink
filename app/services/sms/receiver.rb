class SMS::Receiver
  InvalidSid = Class.new StandardError

  def initialize sid:, to:
    @twilio = TwilioAccount.where(sid: sid, number: to).first || raise(InvalidSid)
  end

  def handle from:, body:
    phone = Phone.for number: from
    user  = override_user(body) || phone.user
    sms   = phone.messages.create! \
      twilio_account: twilio,
      user:           user,
      number:         from,
      text:           body,
      direction:      :incoming

    SMS::Dispatcher.new(twilio: twilio, sms: sms).handler.run!
  rescue SMS::Handler::PresentableError => e
    twilio.send_text to: from, text: e.message
  end

  private

  attr_reader :twilio

  def override_user body
    body =~ /\A@(\w+)/ && User.find_by(pcv_id: $1)
  end
end
