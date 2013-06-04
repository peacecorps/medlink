class SMS

  class ParseError < StandardError ; ; end

  def initialize( data, send_now=false )
    @data     = data
    @send_now = send_now
  end

  def data
    @data
  end

  def send_now( bool )
    @send_now = bool
  end

  def send_now?
    @send_now
  end

  def send
    send_raw data[:to], data[:body]
  end

  def self.parse params
    # grab info from twilio post
    body     = params[:Body]
    data     = Hash.new
    data[:phone] = params[:From]


    if body
      parse_list = params[:Body].split(/,\s*/)
      data[:pcvid], data[:shortcode] = parse_list.shift 2
      parse_list.each do |item| 
        if match = item.match(/([0-9]+)\s*([a-zA-z]+)/) #dosage info
          data[:dosage_value], data[:dosage_units] = match.captures
        elsif match = item.match(/[0-9]+\b/) #qty
          data[:qty] = match[0]
        elsif match = item.match(/[a-zA-z]+\b/) #loc
          data[:loc] = match[0] 
        end
      end
    end

    raise ParseError.new unless data[:pcvid] && data[:shortcode]
    SMS.new data
  end

  def self.send_raw phone, message
    return unless ENV['TWILIO_ACCOUNT_SID']
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => ENV['TWILIO_PHONE_NUMBER'],
        :to   => phone,
        :body => message
    )
  end

  def self.friendly message
    case message
    when /parse/i
      I18n.t! "order.unparseable"
    when /unrecognized pcvid/i
      I18n.t! "order.unrecognized_pcvid"
    when /unrecognized shortcode/i
      I18n.t! "order.unrecognized_shortcode"
    when /duplicate/i
      I18n.t! "order.duplicate_order"
    else
      message
    end.squish
  end

end