module Notification
  class InvalidResponseReceipt < Notification::Base
    def initialize sms:, text:, detail:
      @sms, @text, @detail = sms, text, detail
    end

    def text
      "Could not process ##{@sms.id} (#{@text}) - #{@detail}"
    end
  end
end
