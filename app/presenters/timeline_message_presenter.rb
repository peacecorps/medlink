class TimelineMessagePresenter < Draper::Decorator
  delegate :text

  def type
    :sms
  end

  def description
    "Message"
  end

  def created_at time_zone
    h.short_date model.created_at, time_zone
  end
end
