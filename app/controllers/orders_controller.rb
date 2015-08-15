class OrdersController < ApplicationController
  # The response eager-load may not be used if there aren't any responses yet
  around_action :skip_bullet, only: [:index]

  def index
    @requests = sort_table current_user.requests.includes(orders: [:supply, :response]),
      default: { created_at: :desc }, per_page: 5
  end

  def manage
    authorize :user, :respond?
    users = current_user.country.users
    @past_due = sort_table users.past_due.includes(orders: :supply), prefix: "past_due", default: { waiting_since: :asc }
    @pending  = sort_table users.pending.includes(orders: :supply),  prefix: "pending",  default: { waiting_since: :asc }
  end

  def mark_received
    @order = Order.find params[:id]
    authorize @order
    @order.mark_received!
    @order.response.try :check_for_completion!
    redirect_to :back
  end

  def flag
    @order = Order.find params[:id]
    authorize @order
    @order.flag!
    redirect_to :back
  end
end
