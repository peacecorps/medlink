class OrdersController < ApplicationController
  def index
    @orders = accessible_orders.order created_at: :desc
  end

  def manage
    authorize! :respond, User
    @orders    = accessible_orders
    @responses = accessible_responses
  end

  private

  def accessible_orders
    current_user.accessible(Order).includes :user, :supply, :request
  end

  def accessible_responses
    current_user.accessible(Response)
  end
end
