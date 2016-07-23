module Notification
  class SmsHelpNeeded < Notification::Base
    def initialize sms:
      @sms = sms
    end

    def text
      "It looks like #{name @sms, link: false} is having trouble."
    end

    def slack
      "It looks like #{name @sms, link: true} is having trouble."
    end

    private

    def name sms, link:
      text = sms.user ? sms.user.email : sms.phone.number
      if sms.user && link
        slack_link text, user_timeline_url(sms.user)
      else
        text
      end
    end
  end
end
