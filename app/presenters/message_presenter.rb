class MessagePresenter < ApplicationPresenter
  delegate :text

  def created_at
    "#{short_date model.created_at} @#{model.created_at.strftime '%H:%M'}"
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
