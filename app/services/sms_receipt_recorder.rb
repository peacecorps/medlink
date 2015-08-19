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
    unless outstanding_responses.any?
      send_response I18n.t! "sms.no_outstanding_responses"
      return
    end

    if intent == :flag
      message = response_message "flagged"
      outstanding_responses.each &:flag!
    elsif intent == :approve
      message = response_message "received"
      outstanding_responses.each { |r| r.mark_received! by: user }
    end
    send_response message
  end

private

  def outstanding_responses
    @_outstanding_responses ||= user.responses.where(received_at: nil, flagged: false)
  end

  def response_message type
    orders = Order.where(response: outstanding_responses).includes(:supply)
    SMS::Condenser.new("sms.orders_#{type}", :supply,
      supplies: orders.map { |o| o.supply.name }
    ).message
  end
end
