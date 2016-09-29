module Notification
  class UserActivated < Notification::Base
    def initialize activated:, by:
      @activated, @by = activated, by
    end

    def text
      "#{@activated.pcv_id} re-activated by User ##{@by.id}"
    end
  end
end
