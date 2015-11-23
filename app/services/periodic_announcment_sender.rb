class PeriodicAnnouncementSender
  def initialize announcements: nil
    @now          = Time.now
    @annoucements = announcements || Announcement.find_each
  end

  def send_all
    on_schedule.each do |a|
      Rails.configuration.slackbot.info \
        "Auto-sending annoucement #{a.id} to #{a.country.name}: #{a.message}"
      a.send!
    end
  end

  def on_schedule
    announcements.select { |a| scheduled_for_this_hour?(a) && a.has_been_sent?(within: 1.day) }
  end

private

  attr_reader :now

  def scheduled_for_this_hour? announcement
    now.in_zone(announcement.country.time_zone).hour == announcement.schedule.hour
  end
end
