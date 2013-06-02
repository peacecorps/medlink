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
    reply_to = params[:From]
    body     = params[:Body]

    if body == nil
      raise "Invalid Request. No Data was entered"
    end

    if (data=body.match /(\d{6}),*\s+(\w+),*\s+(\d+)\s*(\w+),*\s+(\d+),*\s+(\w+)/)
      # "111111, BANDG, 30mg, 50, ACCRA"
      data = { 
        :phone        => reply_to,
        :pcvid        => data[1],
        :shortcode    => data[2],
        :dosage_value => data[3],
        :dosage_units => data[4],
        :qty          => data[5],
        :loc          => data[6]
      }
      sms = SMS.new data
    elsif (data=body.match /(\d{6}),*\s+(\w+),*\s+(\d+),*\s+(\w+)/)
      # "111111, BANDG, 50, ACCRA"
      data = { 
        :phone        => reply_to,
        :pcvid        => data[1],
        :shortcode    => data[2],
        :qty          => data[3],
        :loc          => data[4],
      }
      sms = SMS.new data
    elsif (data=body.match /([lL]\w+)\?/)
      # List?
      data = {
        :from => '+17322301185',
        :to   => reply_to,
        :body => %w(meds units country).join( ", ")
      }
      sms = SMS.new data, true
    elsif (data=body.match /([lL]\w+)\s(\w+)/)
      # ["list meds", "list units", "list ghana"]
      if data[2] == "meds" 
        # Future: add filter or send multiple messages
      elsif data[2] == "units"
        # future implementation: add a filter on type of supply
        data = {
          :from => '+17322301185',
          :to   => reply_to,
          :body => "mg, g, ml"
        }
        sms = SMS.new data, true
      end
    else
      raise "Invalid request. Please use this format: pcvid, shortcode, dose/units (if applicable), quantity, location" # not a well-formed sms
    end
    sms
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