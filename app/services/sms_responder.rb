class SMSResponder
  PresentableError = Class.new StandardError

  attr_reader :twilio, :sms

  def initialize twilio:, sms:
    @twilio, @sms = twilio, sms
  end

private

  def user
    @sms.user
  end

  def message
    @sms.text
  end

  def from
    @sms.number
  end

  def error! key, subs={}, opts={}
    msg = if opts[:condense]
      SMS::Condenser.new(key, opts[:condense], subs).message
    else
      I18n.t! key, subs
    end
    raise PresentableError, msg
  end

  def send_response response
    twilio.send_text from, response
  end
end
