class SMS::ReceiptRecorder < SMS::Handler
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

  def run!
    unless outstanding_response && outstanding_response.outstanding?
      error! "sms.no_outstanding_responses"
    end

    if intent == :flag
      receipt_tracker.flag_for_follow_up by: user
      response_message "flagged"
    elsif intent == :approve
      receipt_tracker.mark_received by: user
      response_message "received"
    end
  end

private

  def receipt_tracker
    @_receipt_tracker ||= ReceiptTracker.new(response: outstanding_response)
  end

  def outstanding_response
    @_outstanding_reminder ||= user.receipt_reminders.newest.try(:response)
  end

  def response_message type
    orders = Order.where(response: outstanding_response).includes(:supply)
    SMS::Condenser.new("sms.orders_#{type}", :supply,
      supplies: orders.map { |o| o.supply.name }.uniq
    ).message
  end
end
