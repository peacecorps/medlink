class Announcement < ActiveRecord::Base
  belongs_to :country
  validates_presence_of :country, :message

  serialize :schedule, Schedule

  def send!
    update! last_sent_at: Time.now
    CountrySMSJob.perform_later country: country, message: message
  end

  def self.send_scheduled!
    PeriodicAnnouncementSender.new.send_all
  end

  def has_been_sent? within:
    last_sent_at && last_sent_at > within.ago
  end

  def reach
    @_reach ||= country.textable_pcvs.count
  end

  def days
    schedule ? schedule.days.join(", ") : ""
  end

  def hour
    schedule && schedule.hour
  end
end
