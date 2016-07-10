module Notification
  class SmsHelpNeeded < Notification::Base
    def initialize sms:
      @sms = sms
    end

    def text
      if @sms.user
        "It looks like #{@sms.user.email} is having trouble."
      else
        "It looks like #{@sms.phone.number} is having trouble."
      end
    end

    def slack
      if @sms.user
        "It looks like #{slack_link @sms.user.email, user_timeline_url(@sms.user)} is having trouble."
      else
        "It looks like `#{@sms.phone.number}` is having trouble."
      end
    end

    private

    def name sms, link:
      text = sms.user ? sms.user.email : sms.phone.number
      if link
      else
        text
      end
    end
  end
end
