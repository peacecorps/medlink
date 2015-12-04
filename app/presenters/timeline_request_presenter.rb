class TimelineRequestPresenter < ApplicationPresenter
  delegate :text

  def type
    :request
  end

  def description
    "Request"
  end

  def created_at time_zone
    short_date model.created_at, time_zone
  end

  def orders
    OrderResponsePresenter.decorate_collection model.orders
  end
end
