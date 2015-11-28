class AnnouncementPresenter < Draper::Decorator
  delegate_all

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
