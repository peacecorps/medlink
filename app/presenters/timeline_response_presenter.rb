class TimelineResponsePresenter < ApplicationPresenter
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
    short_date model.created_at, time_zone
  end

  def anchor
    self.class.anchor model.id
  end

  def received_btn klass: nil, text: ""
    klass ||= model.received? ? :success : :default
    h.icon_btn :ok, text, h.mark_received_response_path(model),
      class: klass, title: "Mark as received", disabled: response.received?, method: :post
  end

  def flag_btn klass: nil, text: ""
    klass ||= model.flagged? ? :danger : :default
    h.icon_btn :flag, text, h.flag_response_path(model),
      class: klass, title: "Flag for follow-up", disabled: response.received?, method: :post
  end

  def unique_orders
    orders.reject &:duplicated?
  end

  def delivered_supplies
    model.supplies.where(orders: { delivery_method: DeliveryMethod::Delivery })
  end

  private

  def orders
    OrderResponsePresenter.decorate_collection(model.orders)
  end
end
