class SMS::Handler
  class PresentableError < StandardError
    attr_reader :from

    def initialize msg, from
      super msg
      @from = from
    end
  end

  def initialize sms:
    @sms = sms
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

  attr_reader :sms

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
    raise PresentableError.new msg, self.class
  end

  def user_required!
    error! "sms.unrecognized_user" unless user
  end
end
