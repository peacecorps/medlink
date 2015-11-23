class SMS::ReceiptRecorder < SMS::Handler
  def intent
    if ["yes", "y", "got it", "ok", "okay"].include? message.downcase
      :received
    elsif ["no", "n", "flag"].include? message.downcase
      :flagged
    end
  end

  def valid?
    intent.present?
  end

  def run!
    unless relevant_response
      error! "sms.no_outstanding_responses"
    end

    if intent == :flagged
      receipt_tracker.flag_for_follow_up by: user
    elsif intent == :received
      receipt_tracker.mark_received by: user
    end

    response_message intent
  end

private

  def receipt_tracker
    @_receipt_tracker ||= ReceiptTracker.new(response: outstanding_response)
  end

  def last_reminder
    @_last_reminder ||= user.receipt_reminders.newest
  end

  def relevant_response
    @_relevant_response ||= user.receipt_reminders.newest.try(:response)
    return if @_relevant_response.nil? || @_relevant_response.flagged? || @_relevant_response.archived?
    @_relevant_response
  end

  def unique_supply_names
    outstanding_response.supplies.map(&:name).uniq
  end

  def response_message type
    orders = Order.where(response: outstanding_response).includes(:supply)
    SMS::Condenser.new("sms.orders_#{type}", :supply, supplies: unique_supply_names).message
  end
end
