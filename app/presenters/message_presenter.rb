class MessagePresenter < ApplicationPresenter
  delegate :text

  def created_at
    dt = model.created_at.in_time_zone model.user.time_zone
    "#{short_date dt, model.user.time_zone} @#{dt.strftime '%H:%M'}"
  end

  def user_link
    h.link_to model.user.name, h.user_timeline_path(model.user) if model.user
  end

  def email
    h.mailto model.user.email if model.user
  end

  def number
    h.tel model.number
  end

  def country
    model.user.country.name if model.user
  end
end
