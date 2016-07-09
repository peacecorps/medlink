module Notification
  class Slow < Notification::Base
    def initialize phone:, error:
                        @phone, @error = phone, error
    end

    def text
      "Error while texting #{@phone} - #{@error}"
    end
  end
end
