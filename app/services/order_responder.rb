class OrderResponder
  def initialize user, response
    @user, @response = user, response
  end

  def respond response_params, orders
    @response.update_attributes(response_params) || raise("Failed to update response")
    attach_orders orders.select { |_,data| data.include? "delivery_method" }
    @response.send!
    @response.mark_updated_orders!
    update_waiting! @response.user
    @response.archive! if @response.auto_archivable?
  end

  private #----------

  def attach_orders order_params
    Order.where(id: order_params.keys).each do |o|
      data = order_params[o.id.to_s].merge response_id: @response.id
      o.update_attributes data.permit :delivery_method, :response_id
    end
  end

  def update_waiting! user
    user.update_attributes \
      waiting_since: user.orders.without_responses.minimum(:created_at)
  end
end
