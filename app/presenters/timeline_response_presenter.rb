class TimelineResponsePresenter < Draper::Decorator
  decorates Response
  delegate :user_id, :extra_text

  def self.anchor id
    "response-#{id}"
  end

  def type
    :response
  end

  def description
    "Response"
  end

  def created_at time_zone
    h.short_date model.created_at, time_zone
  end

  def anchor
    self.class.anchor model.id
  end

  def received_btn
    klass = model.received? ? :success : :default
    h.icon_btn :ok, "", h.mark_received_response_path(model),
      class: klass, title: "Mark as received", disabled: response.received?, method: :post
  end

  def flag_btn
    klass = model.flagged? ? :danger : :default
    h.icon_btn :flag, "", h.flag_response_path(model),
      class: klass, title: "Flag for follow-up", disabled: response.received?, method: :post
  end

  def unique_orders
    orders.reject &:duplicated?
  end

  private

  def orders
    OrderResponsePresenter.decorate_collection(model.orders)
  end
end
