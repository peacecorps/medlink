class SMS::ReceiptRecorder < SMS::Handler
  def intent
    if ["yes", "y", "got it", "ok", "okay"].include? stripped
      :received
    elsif ["no", "n", "nope", "flag"].include? stripped
      :flagged
    end
  end

  def valid?
    intent.present?
  end

  def run!
    if response.nil? || response.flagged? || response.archived?
      error! "sms.no_outstanding_responses"
    end

    if intent == :flagged
      receipt_tracker.flag_for_follow_up
    elsif intent == :received
      receipt_tracker.acknowledge_receipt
    end

    response_message intent
  end

private

  def stripped
    message.downcase.gsub(/\W+/, ' ').strip
  end

  def receipt_tracker
    @_receipt_tracker ||= ReceiptTracker.new(response: response, approver: user)
  end

  def last_reminder
    @_last_reminder ||= user.receipt_reminders.newest
  end

  def response
    @_response ||= last_reminder.try(:response)
  end

  def unique_supply_names
    response.supplies.map(&:name).uniq
  end

  def response_message type
    SMS::Condenser.new("sms.orders_#{type}", :supply, supplies: unique_supply_names).message
  end
end
