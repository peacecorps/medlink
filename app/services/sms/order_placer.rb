class SMS::OrderPlacer < SMS::Handler
  def valid?
    parsed
    true
  rescue SMS::Parser::ParseError => e
    # :nocov:
    false
    # :nocov:
  end

  def run!
    user_required!

    if unrecognized_shortcodes.any?
      Notification.send :unrecognized_sms, "#{sms.id}) #{sms.text}"
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
        due_date: due_date(duplicate.request.created_at)
      }, condense: :supply
    end

    create_orders
    confirmation_message
  end

private

  def parsed
    @_parsed ||= SMS::Parser.new(sms.text).tap &:run!
  end

  def create_orders
    form = RequestForm.new user.personal_requests.new
    raise "SMS form failed to validate" unless form.validate( # This _should_ be impossible
      message:  sms,
      supplies: found_supplies,
      text:     parsed.instructions
    )
    form.save
  end

  def supply_names
    @_supply_names ||= found_supplies.map &:select_display
  end

  def duplicate
    @_duplicate ||= sms.last_duplicate within: 1.hour
  end

  def confirmation_message
    SMS::Condenser.new("sms.confirmation", :supply,
      supplies: supply_names,
      due_date: due_date(sms.created_at)
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

  # FIXME: this should be unified(?) with `Order#due_at`
  def due_date created_at
    created_at.at_beginning_of_month.next_month.strftime "%B %d"
  end
end
