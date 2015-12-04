class SMS::Empty < SMS::Handler
  def valid?
    message.strip.empty?
  end

  def run!
    error! "sms.unparseable"
  end
end
