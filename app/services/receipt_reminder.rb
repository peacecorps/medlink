class ReceiptReminder
  def needs_receipt_reminder?
    return false if flagged? || archived?
    return false if created_at >= 7.days.ago # Allow some time for items to arrive.
    return false if created_at < 30.days.ago # _Many_ old orders won't have responses. Don't want to spam folks.

    # No more than once a day
    last_reminded_at = receipt_reminders.maximum :created_at
    last_reminded_at.nil? || last_reminded_at < 1.day.ago
  end

  def send_receipt_reminder!
    return false unless needs_receipt_reminder?

    if receipt_reminders.count >= 3
      flag!
      Rails.configuration.slackbot.message "Flagged response #{id} for manual follow-up after #{receipt_reminders.count} reminders"
      return
    end

    fail "Needs to only include delivered supplies!"
    text = SMS::Condenser.new("sms.response.receipt_reminder", :supply,
      supplies: supply_names, response_date: created_at.strftime("%B %d")).message

    Rails.logger.info "Pinging #{user.email} to acknowledge receipt of response #{id}"
    if sms = user.send_text(text)
      receipt_reminders.create!(user: user, message: sms)
    end
  end

  def sms_instructions
    SMS::Condenser.new("sms.response.#{type}", :supply,
                       supplies: supply_names
                      ).message
  end

  def supply_names
    supplies.uniq.map { |s| "#{s.name} (#{s.shortcode})" }
  end

  def type
    methods = orders.map(&:delivery_method).uniq
    if methods.length == 1
      methods.first.name
    elsif methods.include? DeliveryMethod::Denial
      :partial_denial
    else
      :mixed_approval
    end
  end
end
