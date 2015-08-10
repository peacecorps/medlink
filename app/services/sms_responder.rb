class SMSResponder
  PresentableError = Class.new StandardError


  attr_reader :account_sid, :from, :to, :body, :sms

  def initialize account_sid:, from:, to:, body:
    @account_sid, @from, @to, @body = account_sid, from, to, body
  end

  def valid_sid?
    twilio.present?
  end

  def error! key, subs={}, opts={}
    msg = if opts[:condense]
      SMS::Condenser.new(key, opts[:condense], subs).message
    else
      I18n.t! key, subs
    end
    raise PresentableError, msg
  end

  def record_and_respond
    record_receipt

    unless user
      error! "sms.unrecognized_user"
    end

    if unrecognized_shortcodes.any?
      error! "sms.unrecognized_shortcodes",
        { codes: unrecognized_shortcodes }, condense: :code
    end

    if unavailable_supplies.any?
      error! "sms.invalid_for_country",
        { codes: unavailable_supplies, country: user.country.name}, condense: :code
    end

    if duplicate
      error! "sms.duplicate_order", {
        supplies: supply_names,
        due_date: Request.due_date(duplicate.request.created_at)
      }, condense: :supply
    end

    create_orders
    send_response confirmation_message
  rescue PresentableError => e
    send_response e.message
  end

  def record_receipt
    @sms = SMS.create! \
      user:           user,
      twilio_account: twilio,
      number:         from,
      text:           body,
      direction:      :incoming
  end

  def send_response response
    twilio.send_text from, response
  end

private

  def twilio
    @_twilio ||= TwilioAccount.where(sid: account_sid, number: to).first
  end

  def user
    @_user ||= if parsed.pcv_id
      User.find_by_pcv_id parsed.pcv_id
    else
      User.find_by_phone_number from
    end
  end

  def parsed
    @_parsed ||= SMS::Parser.new(body).tap &:run!
  rescue SMS::Parser::ParseError => e
    error! "sms.unparseable"
  end

  def create_orders
    orders = found_supplies.map { |s| { supply_id: s.id } }
    rc = RequestCreator.new(user, orders: orders, request: {
      message_id:        sms.id,
      user_id:           user.id,
      text:              parsed.instructions
    })
    rc.save
    sms.update request: rc.request
  end

  def supply_names
    @_supply_names ||= found_supplies.map { |s| "#{s.name} (#{s.shortcode})" }
  end

  def duplicate
    @_duplicate ||= sms.duplicate within: 1.hour
  end

  def confirmation_message
    SMS::Condenser.new("sms.confirmation", :supply,
      supplies: supply_names,
      due_date: Request.due_date(sms.created_at)
    ).message
  end

  def shortcodes
    @_shortcodes ||= parsed.shortcodes.map(&:upcase)
  end

  def found_supplies
    @_found_supplies ||= Supply.where(shortcode: shortcodes)
  end

  def unrecognized_shortcodes
    shortcodes - found_supplies.map(&:shortcode)
  end

  def unavailable_supplies
    shortcodes - user.country.supplies.map(&:shortcode)
  end
end
