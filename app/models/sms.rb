class SMS

  class ParseError < StandardError ; ; end

  attr_accessor :phone, :message

  def initialize phone, message
    @phone   = phone
    @message = message
  end

  def self.configured?
    %w{ ACCOUNT_SID AUTH PHONE_NUMBER }.all? do |key|
      ENV["TWILIO_#{key}"].present?
    end
  end

  def self.parse params
    body = params[:Body]
    data = { phone: params[:From] }

    if body
      parse_list = params[:Body].split(/,\s*/)
      data[:pcvid], data[:shortcode], data[:loc] = *parse_list
    end

    raise ParseError.new unless data[:pcvid] && data[:shortcode]
    data
  end

  def deliver
    return unless SMS.configured? || defined?(SmsSpec)
    # In the test env, this client should be monkey-patched by sms-spec
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'],
                                      ENV['TWILIO_AUTH'])
    client.account.sms.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   phone,
      body: message
    )
  end

  def self.friendly message
    translation = case message
    when /unrecognized pcvid/i
      "order.unrecognized_pcvid"
    when /unrecognized shortcode/i
      "order.unrecognized_shortcode"
    when /supply has already been taken/i
      "order.duplicate_order"
    end

    I18n.t!(translation).squish
  end

end
