class SMS < ActiveRecord::Base
  self.table_name = "messages"

  enum direction: [ :incoming, :outgoing ]

  has_many :orders, foreign_key: :message_id

  def self.deliver number, text
    SMS.create number: number, text: text, direction: :outgoing

    sid, auth = %w(ACCOUNT_SID AUTH).map { |k| ENV.fetch "TWILIO_#{k}" }
    client = Twilio::REST::Client.new sid, auth
    client.account.sms.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   number,
      body: text
    )
  end

  def user
    @_user ||= if parsed.pcv_id
      User.find_by_pcv_id parsed.pcv_id
    else
      User.find_by_phone_number number
    end
  end

  def supplies
    @_supplies ||= begin
      codes  = parsed.shortcodes.map &:upcase
      found  = Supply.where shortcode: codes
      missed = codes - found.map(&:shortcode)
      raise "Unrecognized shortcodes: #{missed.join ', '}" if missed.any?
      found
    end
  end

  def create_orders
    supplies.each do |supply|
      orders.create!(
        user_id:      user.id,
        supply_id:    supply.id,
        instructions: parsed.instructions,
        entered_by:   user.id
      )
   end
  end

  def send_confirmation orders
    names = supplies.map { |s| "#{s.name} (#{s.shortcode})" }
    body = "Request received: #{names.join ', '}"
    if body.length > 160
      body = "Request received: #{names.first} & #{names.length - 1} other items"
    end
    SMS.deliver number, body
  end

  def self.friendly message
    translation = case message
    when /unrecognized pcvid/i
      "order.unrecognized_pcvid"
    when /unrecognized shortcode/i
      "order.unrecognized_shortcode"
    when /supply has already been taken/i
      "order.duplicate_order"
    when /failed to parse/i
      "order.parse_error"
    else
      raise NotImplementedError, "Can't translate '#{message}'"
    end

    I18n.t!(translation).squish
  end

  private

  def parsed
    @_parsed ||= Parser.new(text).tap &:run!
  end
end
