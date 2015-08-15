class SMSReceiptRecorder < SMSResponder
  def intent
    if ["yes", "y", "got it", "ok", "okay"].include? message.downcase
      :approve
    elsif ["no", "n", "flag"].include? message.downcase
      :flag
    end
  end

  def valid?
    intent.present?
  end

  def respond
    unless outstanding_orders.any?
      send_response I18n.t! "sms.no_outstanding_orders"
      return
    end

    if intent == :flag
      outstanding_orders.each &:flag!
      send_response response_message "flagged"
    elsif intent == :approve
      outstanding_orders.each &:mark_received!
      send_response response_message "received"
    end
  end

private

  def outstanding_orders
    @_outstanding_orders ||= user.orders.includes(:supply, :response).
      reject { |o| o.response.try(:archived?) || o.received? }
  end

  def response_message type
    SMS::Condenser.new("sms.orders_#{type}", :supply,
      supplies: outstanding_orders.map { |o| o.supply.name }
    ).message
  end
end
