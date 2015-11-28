class Announcement < ActiveRecord::Base
  belongs_to :country
  validates_presence_of :country, :message

  serialize :schedule, Schedule

  def self.scheduled
    where.not(schedule: nil).select { |a| a.schedule.next_run.present? }
  end

  def self.next count
    scheduled.min_by(count) { |a| a.schedule.next_run }
  end

  def send!
    update! last_sent_at: Time.now
    CountrySMSJob.perform_later country: country, message: message
  end

  def has_been_sent? within:
    last_sent_at && last_sent_at > within.ago
  end
end
