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
    return false unless schedule = announcement.schedule
    now_zone = now.in_time_zone announcement.country.time_zone
    now_zone.hour == schedule.hour && schedule.days.include?(now_zone.day)
  end

  def on_schedule
    announcements.select { |a| scheduled_for_this_hour?(a) && !a.has_been_sent?(within: 22.hours) }
  end
end
