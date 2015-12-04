class PeriodicAnnouncementSender
  def initialize announcements: nil
    @announcements = announcements || Announcement.find_each
    @now           = Time.now
  end

  def send_scheduled
    on_schedule.each do |a|
      Notification.send :announcement_scheduled,
        "Auto-sending annoucement #{a.id} to #{a.country.name}: #{a.message}"
      a.send!
    end
  end

private

  attr_reader :announcements, :now

  def scheduled_for_this_hour? announcement
    now.in_time_zone(announcement.country.time_zone).hour == announcement.schedule.hour
  end

  def on_schedule
    announcements.select { |a| scheduled_for_this_hour?(a) && !a.has_been_sent?(within: 22.hours) }
  end
end
