module Notification
  class UnrecognizedSMS < Notification::Base
    def initialize sms:
      @sms = sms
    end

    def text
      "Unhandled SMS (##{@sms.id}): `#{@sms.text}`"
    end
  end
end
