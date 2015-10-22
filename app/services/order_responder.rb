class OrderResponder
  attr_reader :responded_by, :response

  def initialize responded_by:, response:
    @responded_by, @response = responded_by, response
  end

  def respond params, orders
    response.set_text params[:extra_text]
    response.save!
    attach_orders orders.select { |_,data| data.include? "delivery_method" }
    response.send!
    response.mark_updated_orders!
    update_waiting! response.user
    queue_receipt_reminders! response
    if response.auto_archivable?
      response.mark_received! by: responded_by
    end
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

  def queue_receipt_reminders! response
    [14, 17, 20, 23].each do |offset|
      at = response.created_at + offset.days
      ReceiptReminderJob.set(wait_until: at).perform_later response
    end
  end
end
