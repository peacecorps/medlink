class SMS::OrderPlacer < SMS::Handler
  def valid?
    parse!
    shortcodes.present?
  end

  def run!
    parse!
    user_required!

    check_for_unrecognized
    check_for_unavailable
    check_for_duplicate

    create_orders
    confirmation_message
  end

private

  attr_reader :instructions, :shortcodes

  def parse!
    return if shortcodes.present?
    parsed = SMS::Parser.new(sms.text).run!
    @instructions, @shortcodes = parsed.instructions, parsed.shortcodes
  end

  def check_for_unrecognized
    return unless unrecognized_shortcodes.any?
    Notification.send :unrecognized_sms, "#{sms.id}) #{sms.text}"
    error! "sms.unrecognized_shortcodes",
           { codes: unrecognized_shortcodes }, condense: :code
  end

  def check_for_unavailable
    return unless unavailable_supplies.any?
    error! "sms.invalid_for_country",
           { codes: unavailable_supplies, country: user.country.name}, condense: :code
  end

  def check_for_duplicate
    return unless duplicate
    error! "sms.duplicate_order", {
      supplies: supply_names,
      due_date: DueDate.new(duplicate.request)
    }, condense: :supply
  end

  def create_orders
    form = RequestForm.new user.personal_requests.new
    raise "SMS form failed to validate" unless form.validate( # This _should_ be impossible
      message:  sms,
      supplies: found_supplies,
      text:     instructions
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
      due_date: DueDate.new(sms)
    ).message
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
