class Announcement < ActiveRecord::Base
  belongs_to :country
  validates_presence_of :message

  def self.send_scheduled!
    Announcement.find_each do |announcement|
      next unless announcement.scheduled_for_this_hour?
      next unless announcement.sendable?
      announcement.send!
    end
  end

  def schedule= s
    self[:schedule] = s.to_json
  end
  def schedule
    Schedule.new self[:schedule]
  end

  def days
    schedule.days.join ","
  end

  def hour
    schedule.hour
  end

  def schedule_for_month ts
    eom = ts.end_of_month.day + 1
    schedule.days.map do |offset|
      if offset > 0
        ts.change(day: offset, hour: hour)
      else
        ts.change(day: eom + offset, hour: hour)
      end
    end
  end

  def preview
    return unless schedule.days.any?
    now = Time.now
    days = schedule_for_month(now).map { |t| "#{t.day}#{t.day.ordinal}" }
    "#{now.strftime("%b")} #{days.to_sentence} at #{hour}"
  end

  def sendable?
    last_sent_at.nil? || last_sent_at < 1.day.ago
  end

  def send!
    update! last_sent_at: Time.now
    CountrySMSJob.perform_later country, message
  end

  def reach
    @_reach ||= country.textable_pcvs.count
  end

  def scheduled_for_this_hour?
    zoned(Time.now).hour == hour
  end

  def zoned time
    time.in_zone(country.time_zone)
  end
end
