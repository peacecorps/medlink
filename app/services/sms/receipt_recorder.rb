class SMS::ReceiptRecorder < SMS::Handler
  Received = :received
  Flagged  = :flagged

  def intent
    return @intent if @intent

    classifier = Classifier.new
    @intent = if classifier.affirmative? stripped
      Received
    elsif classifier.negative? stripped
      Flagged
    end
  end

  def valid?
    intent.present?
  end

  def run!
    verify_user_and_response!

    if intent == Flagged
      receipt_tracker.flag_for_follow_up
    elsif intent == Received
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
    @_last_reminder ||= user.try(:receipt_reminders).try(:newest)
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

  def verify_user_and_response!
    if user.nil?
      Medlink.notify Notification::InvalidResponseReceipt.new \
                                                            sms: sms, text: stripped, detail: "no user recognized"
      error! "sms.unrecognized_user"
    elsif response.nil?
      Medlink.notify Notification::InvalidResponseReceipt.new \
                                                            sms: sms, text: stripped, detail: "no responses found"
      error! "sms.no_outstanding_responses"
    elsif response.flagged? || response.archived?
      # This isn't necessarily an error, but we probably want to know if
      # it's happening
      Medlink.notify Notification::ReprocessingResponseReceipt.new \
                                                                 sms: sms, text: stripped, previous: response
    end
  end
end

