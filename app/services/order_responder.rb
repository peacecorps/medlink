class OrderResponder
  def initialize user, response
    @user, @response = user, response
  end

  def respond response_params, orders
    @response.update_attributes(response_params) || raise("Failed to update response")
    attach_orders orders.select { |_,data| data.include? "delivery_method" }
    @response.send!
    @response.mark_updated_orders!
    @response.user.update_waiting!
    if @response.orders.all? { |o| o.delivery_method.auto_archive? }
      @response.archive!
    end
  end

  private #----------

  def attach_orders order_params
    Order.
      where(id: order_params.keys).
      includes(:request, :user, :country, :supply).each do |o|
        data = order_params[o.id.to_s].merge response_id: @response.id
        o.update_attributes data.permit :delivery_method, :response_id
    end
  end
end
