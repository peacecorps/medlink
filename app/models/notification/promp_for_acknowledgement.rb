module Notification
  class PromptForAcknowledgement < Notification::Base
    def initialize volunteer:, response:
      @volunteer, @response = volunteer, response
    end

    def text
      "Pinging #{@volunteer.email} to acknowledge receipt of response #{@response.id}"
    end
  end
end
