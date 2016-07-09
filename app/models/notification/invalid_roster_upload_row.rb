module Notification
  class InvalidRosterUploadRow < Notification::Base
    def initialize row:, action:, error:
      @row, @action, @error = row, action, error
    end

    def text
      "Failed to #@action from upload row #{@row.user_hash}: #@error"
    end
  end
end
