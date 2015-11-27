class ReceiptAckPrompt
  def initialize response
    @response = response
  end

  def send
    return unless needs_receipt_reminder?
    if reminder_count >= 3
      flag_for_follow_up
      return
    end

    send_receipt_reminder
  end

  private

  attr_reader :response

  def outstanding?
    !(response.flagged? || response.received_at)
  end

  def responded_at
    response.created_at
  end

  def last_reminded_at
    @_last_reminded_at ||= response.receipt_reminders.maximum :created_at
  end

  def reminder_count
    @_reminder_count ||= response.receipt_reminders.count
  end

  def volunteer
    response.user
  end

  def needs_receipt_reminder?
    return false unless outstanding?
    return false unless delivered_supplies.any?
    return false if responded_at >= 7.days.ago # Allow some time for items to arrive.
    return false if responded_at < 30.days.ago # _Many_ old orders won't have responses. Don't want to spam folks.

    # No more than once a day
    last_reminded_at.nil? || last_reminded_at < 1.day.ago
  end

  def flag_for_follow_up
    response.update! flagged: true
    Notification.send :flag_for_followup,
      "Flagged response #{response.id} for manual follow-up after #{reminder_count} reminders"
  end

  def reminder_text
    SMS::Condenser.new("sms.response.receipt_reminder", :supply,
      supplies: delivered_supplies.map(&:select_display), response_date: responded_at.strftime("%B %d")).message
  end

  def delivered_supplies
    @_delivered_supplies ||= response.orders.includes(:supply).
      select { |o| o.delivery_method == DeliveryMethod::Delivery }.
      map(&:supply).
      uniq
  end

  def send_receipt_reminder
    Notification.send :prompt_for_ack, \
      "Pinging #{volunteer.email} to acknowledge receipt of response #{response.id}"

    if sms = volunteer.send_text(reminder_text)
      response.receipt_reminders.create!(user: volunteer, message: sms)
    end
    sms
  end
end
