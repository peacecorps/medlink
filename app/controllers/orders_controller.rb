class OrdersController < ApplicationController
  def index
    @orders = SortTable.new current_user.orders.includes(:request, :supply, :response),
      params: params
  end

  def manage
    authorize :user, :respond?
    users = current_user.country.users
    @past_due = SortTable.new users.past_due,
      params: params, prefix: "past_due", default: { waiting_since: :asc }
    @pending = SortTable.new users.pending,
      params: params, prefix: "pending",  default: { waiting_since: :asc }
  end
end
