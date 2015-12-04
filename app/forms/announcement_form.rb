class AnnouncementForm < Reform::Form
  property :announcer, virtual: true
  property :days, virtual: true
  property :hour, virtual: true
  property :message
  property :country_id
  property :schedule

  validates :country_id, presence: true
  validates :message, presence: true
  validate :no_partial_schedule
  validate :only_admins_schedule

  def days
    schedule.days.join ", " if schedule
  end
  def days= d
    schedule.days = d.split(",").map(&:strip)
  end

  def hour
    schedule.hour if schedule
  end
  def hour= h
    schedule.hour = h
  end
  def hour_choices
    (0..23).map { |i| [i.to_s.rjust(2, "0"), i] }
  end

  def preview
    schedule.preview if schedule
  end

  def initialize *args
    super
    self.schedule ||= Schedule.new
  end

  def save
    self.schedule = nil if schedule.days.none?
    super
  end

  private

  def no_partial_schedule
    if schedule.days.any? && !schedule.hour.present?
      errors.add :hour, "required for scheduled announcements"
    end
  end

  def only_admins_schedule
    if schedule.days.any? && !announcer.admin?
      errors.add :days, "only admins can schedule repeated announcements"
    end
  end
end
