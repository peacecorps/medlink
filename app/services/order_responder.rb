class OrderResponder
  def initialize response
    @response = response
  end

  def run text: nil, selections:
    update_response text: text
    attach_orders selections: selections
    send_notifications
    mark_updated_orders
    update_wait_times
    queue_receipt_reminders if deliveries_pending?
    check_auto_archive
    response
  end

  private

  attr_reader :response

  def requester
    response.user
  end

  def delivery_methods
    response.orders.map(&:delivery_method).compact
  end

  def update_response text:
    response.update! extra_text: text
  end

  def attach_orders selections:
    selections.each do |order, method|
      order.delivery_method = method
      order.response = response
      order.save!
    end
  end

  def send_notifications
    ResponseSMSJob.perform_later response
    UserMailer.fulfillment(response).deliver_later
  end

  def mark_updated_orders
    requester.orders.
      where(supply: response.supplies, delivery_method: nil).
      update_all response_id: response.id
  end

  def update_wait_times
    requester.update_attributes! \
      waiting_since: requester.orders.without_responses.minimum(:created_at)
  end

  def deliveries_pending?
    delivery_methods.include? DeliveryMethod::Delivery
  end

  def queue_receipt_reminders
    [14, 17, 20, 23].each do |offset|
      at = response.created_at + offset.days
      PromptForReceiptAcknowledgementJob.set(wait_until: at).perform_later response
    end
  end

  def check_auto_archive
    if delivery_methods.all? &:auto_archive?
      response.update! archived_at: Time.now
    end
  end
end
