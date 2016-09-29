module Notification
  class UnrecognizedSMS < Notification::Base
    def initialize sms:
      @sms = sms
    end

    def text
      if @sms.user
        "Unhandled SMS (##{@sms.id}) for #{@sms.user.pcv_id}: `#{@sms.text}`"
      else
        "Unhandled SMS (##{@sms.id}) for #{@sms.phone.number}: `#{@sms.text}`"
      end
    end

    def slack
      if @sms.user
        "Unhandled SMS (##{@sms.id}) for #{slack_link @sms.user.pcv_id, user_timeline_url(@sms.user)}: `#{@sms.text}`"
      else
        "Unhandled SMS (##{@sms.id}) for #{@sms.phone.number}: `#{@sms.text}`"
      end
    end
  end
end
