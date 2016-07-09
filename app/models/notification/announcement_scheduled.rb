module Notification
  class AnnouncementScheduled < Notification::Base
    def initialize announcement:
      @announcement = announcement
    end

    def text
      "Auto-sending annoucement #{@announcement.id} to #{@announcement.country.name}: #{@announcement.message}"
    end
  end
end
