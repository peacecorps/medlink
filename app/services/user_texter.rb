class UserTexter
  class Error < StandardError; end

  def initialize user: nil, number: nil, twilio_account: nil, deliverer: nil
    @user = user || User.find_by_phone_number(number)
    raise Error, "Must provide either a user or number to text" unless user || number

    @number           = number || user.primary_phone.try(:number)
    @condensed_number = Phone.condense self.number if self.number

    @twilio    = twilio_account || (user && user.country.twilio_account) || TwilioAccount.first!
    @deliverer = deliverer || self.twilio.client.messages.method(:create)
  end

  def send message
    return false unless number
    return false if spammy? message
    recorded_message = record message
    begin
      deliver message
    rescue Twilio::REST::RequestError => e
      note_delivery_failure e
    end
    recorded_message
  end

  def spammy? message
    last = last_sent_message
    last && last.text == message && last.outgoing? && last.created_at >= 2.days.ago
  end

  protected

  attr_reader :user, :number, :condensed_number, :twilio, :deliverer

  def last_sent_message
    if user
      SMS.outgoing.where(user: user).newest
    else
      SMS.outgoing.where(number: condensed_number).newest
    end
  end

  def record message
    SMS.create!(
      twilio_account: twilio,
      user:           user,
      number:         condensed_number,
      text:           message,
      direction:      :outgoing
    )
  end

  def deliver message
    deliverer.(
      from: twilio.number,
      to:   condensed_number,
      body: message
    )
  end

  def note_delivery_failure error
    Rails.logger.error "Error while texting #{number} - #{error}"
    if phone = Phone.lookup(number)
      phone.update! send_error: error
    end
  end
end
