class SMS

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
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => data[:to],
        :body => data[:body]
    )
  end

  def self.parse params
    # grab info from twilio post
    body     = params[:Body]
    data     = Hash.new
    data[:phone] = params[:From]


    if body
      if body.match(/([lL]\w+)\s(\w+)/) 
        return SMS.new list(params), true
      end

      parse_list = params[:Body].split(/,\s*|\s/)
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

      return SMS.new data
    else 
      raise "Invalid Request"
    end
  end

  def self.list params
    #function stub for future implementation of list command
  end

  def self.send_raw phone, message
    return unless ENV['TWILIO_ACCOUNT_SID']
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => phone,
        :body => message
    )
  end

  def self.send_from_order order
    self.send_raw order.phone, order.confirmation_message
  end

  def self.send_error phone, message
    self.send_raw phone, friendly(message)
  end

  def self.friendly message
    case message
    when /unrecognized pcvid/i
      %{ Your request was not submitted because the PCVID was incorrect. Please resubmit 
         your request in this format: PCVID, Supply short name, dose, qty, location. }
    when /unrecognized shortcode/i
      %{ Your request was not submitted because supply name was incorrect. Please resubmit 
         the request in this format: PCVID, Supply short name, dose, qty, location. }
    when /duplicate/i
      %{ We have already received your request. Please refrain from 
         sending multiple requests. }
    when /parse/i
      %{ Your request was not submitted. Please resubmit your request in this Format: 
         PCVID,Supply short name, dose, qty, location. }
    else
      message
    end.squish
  end

end