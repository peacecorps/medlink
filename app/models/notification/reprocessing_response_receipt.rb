module Notification
  class ReprocessingResponseReceipt < Notification::Base
    def initialize sms:, text:, previous:
      @sms, @text, @previous = sms, text, previous
    end

    def text
      "Re-processing sms ##{@sms.id} (#{@text}) - response _was_ flagged:#{@previous.flagged?} / archived:#{@previous.archived?}"
    end
  end
end
