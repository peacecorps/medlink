module Notification
  class AnnouncementScheduled < Notification::Base
    def initialize announcement:
      @announcement = announcement
    end

    def text
      "Auto-sending annoucement #{@announcement.id} to #{@announcement.country.name}: #{@announcement.message}"
    end

    def slack
      "Auto-sending announcement #{slack_link @announcement.id, edit_announcement_url(@announcement)} to #{@announcement.country.name}: #{@announcement.message}"
    end
  end
end
