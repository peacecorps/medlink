class SMS < ActiveRecord::Base
  MAX_LENGTH = 160

  self.table_name = "messages"

  enum direction: [ :incoming, :outgoing ]

  has_one :request, foreign_key: :message_id

  def self.receive number, text
    sms = SMS.create number: number, text: text, direction: :incoming
    sms.check_duplicates! 1.hour
    sms.create_orders!
    sms.send_confirmation!
  end

  def self.deliver number, text
    sms = SMS.create number: number, text: text, direction: :outgoing

    sid, auth = %w(ACCOUNT_SID AUTH).map { |k| ENV.fetch "TWILIO_#{k}" }
    client = Twilio::REST::Client.new sid, auth
    client.account.sms.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   number,
      body: text
    )

    sms
  end

  def user
    @_user ||= if parsed.pcv_id
      User.find_by_pcv_id parsed.pcv_id
    else
      User.find_by_phone_number number
    end
  rescue ActiveRecord::RecordNotFound => e
    raise FriendlyError.new "sms.unrecognized_user"
  end

  def check_duplicates! span
    if dup = find_duplicate(span)
      raise FriendlyError.new "sms.duplicate_order", {
        supplies: supply_names,
        due_date: Request.due_date(dup.request.created_at)
      }, condense: :supply
    end
  end

  def create_orders!
    request = Request.create!(
      message_id: id,
      user:       user,
      text:       parsed.instructions,
      entered_by: user.id
    )
    supplies.each do |supply|
      request.orders.create!(
        user:      user,
        supply_id: supply.id,
      )
    end
    user.mark_updated_orders
  end

  def confirmation_message
    Condenser.new("sms.confirmation", :supply,
      supplies: supply_names,
      due_date: Request.due_date(created_at)
    ).message
  end

  def send_confirmation!
    SMS.deliver number, confirmation_message
  end

  private

  def parsed
    @_parsed ||= Parser.new(text).tap &:run!
  end

  def supplies
    @_supplies ||= Supply.find_by_shortcodes parsed.shortcodes
  end

  def supply_names
    @_supply_names ||= supplies.map { |s| "#{s.name} (#{s.shortcode})" }
  end

  def find_duplicate span
    SMS.incoming.
      where(text: text).
      where(["created_at >= ?", span.ago]).
      where(["id != ?", id]).
      last
  end
end
