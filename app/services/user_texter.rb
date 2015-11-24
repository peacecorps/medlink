class UserTexter
  class Error < StandardError; end

  def initialize phone:, twilio_account: nil, deliverer: nil
    @phone     = phone
    @twilio    = twilio_account || default_account
    @deliverer = deliverer || self.twilio.client.messages.method(:create)
  end

  def send message
    return false if spammy? message
    sms = record message
    begin
      deliver message
    rescue Twilio::REST::RequestError => e
      note_delivery_failure sms, e
    end
    watch_for_send_volume
    sms
  end

  def spammy? message
    last = last_sent_message
    last && last.text == message && last.outgoing? && last.created_at >= 2.days.ago
  end

  protected

  attr_reader :phone, :twilio, :deliverer

  def user
    phone.user
  end

  def default_account
    TwilioAccount.first!
  end

  def last_sent_message
    filter = user ? { user: user } : { phone: phone }
    SMS.outgoing.where(filter).newest
  end

  def record message
    SMS.create!(
      twilio_account: twilio,
      user:           user,
      phone:          phone,
      number:         phone.condensed,
      text:           message,
      direction:      :outgoing
    )
  end

  def deliver message
    deliverer.(
      from: twilio.number,
      to:   phone.number,
      body: message
    )
  end

  def watch_for_send_volume time: 1.hour
    sent = phone.messages.outgoing.where("created_at > ?", time.ago).count
    if sent > 3
      config.slackbot.info "Warning - #{phone.number} has received #{sent} messages in #{time}."
    end
  end

  def note_delivery_failure message, error
    Rails.logger.error "Error while texting #{phone} - #{error}"
    phone.update!   send_error: error
    message.update! send_error: error
  end
end
