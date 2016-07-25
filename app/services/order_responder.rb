class OrderResponder
  def self.build
    new notifier: Medlink.notifier, recorder: ResponseRecorder.new
  end

  def initialize notifier:, recorder:
    @recorder, @notifier = recorder, notifier
  end

  def build user_id:, text: nil, selections: {}
    user = User.find user_id
    response = user.responses.new country_id: user.country_id, extra_text: text
    Order.find(selections.keys).each do |order|
      order.delivery_method = selections.fetch(order.id)
      response.orders << order
    end
    response
  end

  def save response
    return if response.orders.none?
    recorder.call response
    notifier.call Notification::ResponseCreated.new response
    queue_receipt_reminders response
    response
  end

  private

  attr_reader :recorder, :notifier

  def queue_receipt_reminders response
    return unless response.orders.any? { |o| o.delivery_method == DeliveryMethod::Delivery }
    [14, 17, 20, 23].each do |offset|
      at = response.created_at + offset.days
      PromptForReceiptAcknowledgementJob.set(wait_until: at).perform_later response
    end
  end
end
