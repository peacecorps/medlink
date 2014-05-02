class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.
      includes(:request, :supply, :response).
      page(params[:page])
  end

  def manage
    authorize! :respond, User
    @past_due = accessible_orders.past_due.page params[:past_due_page]
    @pending  = accessible_orders.pending.page params[:pending_page]
  end

  private

  def accessible_orders
    current_user.
      accessible(Order).
      where(country_id: active_country_id).
      includes :user, :supply
  end
end
