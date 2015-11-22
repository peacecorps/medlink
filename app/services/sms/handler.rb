class SMS::Handler
  PresentableError = Class.new StandardError

  def initialize twilio:, sms:
    @twilio, @sms = twilio, sms
  end

  # :nocov:
  def valid?
    raise NotImplementedError
  end

  def run!
    raise NotImplementedError
  end
  # :nocov:

  private

  attr_reader :twilio, :sms

  def user
    sms.user
  end

  def message
    sms.text
  end

  def error! key, subs={}, opts={}
    msg = if opts[:condense]
      SMS::Condenser.new(key, opts[:condense], subs).message
    else
      I18n.t! key, subs
    end
    raise PresentableError, msg
  end

  def user_required!
    error! "sms.unrecognized_user" unless user
  end
end
