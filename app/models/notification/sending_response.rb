module Notification
  class SendingResponse < Notification::Base
    def initialize response:
      @response = response
    end

    def text
      "Sending SMS for response ##{@response.id}"
    end
  end
end
