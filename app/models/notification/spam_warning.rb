module Notification
  class SpamWarning < Notification::Base
    def initialize phone:, count:, time:
      @phone, @count, @time = phone, count, time
    end

    def text
      "Warning - #{@phone.number} has received #@count messages in #{@time}s."
    end
  end
end
