class Schedule
  include Virtus.model

  attribute :days, Array[Integer]
  attribute :hour, Integer

  def self.load s
    return unless s
    return s if s.is_a? Schedule
    Schedule.new s
  end

  def self.dump s
    s.to_json
  end

  def == other
    other && days == other.days && hour == other.hour
  end

  def preview
    return unless days.any?
    now = Time.now
    days = schedule_for_month(now).map { |t| "#{t.day}#{t.day.ordinal}" }
    "#{now.strftime("%b")} #{days.to_sentence} at #{hour.to_s.rjust 2, '0'}:00"
  end

  def next_run
    return unless days.any?
    now  = Time.now
    span = schedule_for_month(now) + schedule_for_month(now + 1.month)
    span.find { |d| d > now }
  end

private

  def schedule_for_month ts
    eom = ts.end_of_month.day + 1
    days.map do |offset|
      next if offset > eom || offset < - eom
      if offset > 0
        ts.change(day: offset, hour: hour)
      else
        ts.change(day: eom + offset, hour: hour)
      end
    end.compact.sort
  end
end
