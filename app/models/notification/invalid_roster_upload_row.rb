module Notification
  class InvalidRosterUploadRow < Notification::Base
    def initialize row:, action:, error:
      @row, @action, @error = row, action, error
    end

    def text
      "Failed to #@action from upload row #{@row.user_hash[:pcv_id]}: #@error"
    end
  end
end
