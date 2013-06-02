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

      parse_list = params[:Body].split(/[, ]/)
      parse_list.each_index { |i| 
        if i == 0
          data[:pcvid] = parse_list[i] #pcvID
        elsif i == 1
          data[:shortcode] = parse_list[i] #shortcode
        elsif match = parse_list[i].match(/([0-9]+)\s*([a-zA-z]+)/) #dosage info
          data[:dosage_value], data[:dosage_units] = match.captures
        elsif match = parse_list[i].match(/[0-9]+\b/) #qty
          data[:qty] = match[0]
        elsif match = parse_list[i].match(/[a-zA-z]+\b/) #loc
          data[:loc] = match[0] 
        end
      }

      return SMS.new data
    else 
      raise "Invalid Request"
    end
  end

  def self.list params
    #function stub for future implementation of list command
  end

  def self.send_from_order order
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => order.phone,
        :body => order.confirmation_message
    )
  end

  def self.send_error phone, message
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => phone,
        :body => message
    )
  end

end