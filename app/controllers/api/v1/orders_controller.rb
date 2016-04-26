class Api::V1::OrdersController < Api::V1::BaseController
  def index
    @orders = current_user.outstanding_orders
  end
end
