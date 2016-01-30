class MessagePresenter < ApplicationPresenter
  delegate :text

  def created_at
    tz = model.user ? model.user.time_zone : Rails.configuration.time_zone
    dt = model.created_at.in_time_zone tz
    "#{short_date dt} @#{dt.strftime '%H:%M'}"
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
