class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.
      includes(:request, :supply, :response).
      page(params[:page])
  end

  def manage
    authorize! :respond, User
    @past_due = users :past_due, params[:past_due_page], params[:past_due_sort]
    @pending  = users :pending,  params[:pending_page],  params[:pending_sort]
  end

  private

  def users type, page, sort
    rel = User.
      where(country_id: active_country_id).
      send(type).
      page(page || 1)
    sort ? rel.order(sort) : rel
  end
end
