module Notification
  class UserActivated < Notification::Base
    def initialize activated:, by:
      @activated, @by = activated, by
    end

    def text
      "#{@activated.email} re-activated by #{@by.email}"
    end
  end
end
