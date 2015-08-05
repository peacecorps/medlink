class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.
      includes(:request, :supply, :response).
      page(params[:page])
  end

  def manage
    authorize :user, :respond?
    @past_due = users :past_due
    @pending  = users :pending
  end

  private

  def users type
    current_user.country.users.
      send(type).
      order(order "#{type}_").
      page(params["#{type}_page"] || 1)
  end

  def order prefix
    "#{sort_column prefix} #{sort_direction prefix}"
  end
end
