class SMS::Help < SMS::Handler
  def valid?
    sms.text.strip =~ /"?help"?/i
  end

  def run!
    Medlink.notify Notification::SmsHelpNeeded.new(sms: sms)
    %|Okay, I've paged a human who will get in touch with you as soon as possible.|
  end
end
