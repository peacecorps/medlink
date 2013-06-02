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
    reply_to = params[:From]
    body     = params[:Body]
    data     = nil

    if body      
      if body.match /(\d{6}),*\s+(\w+),*\s+(\d+)(\w+),*\s+(\d+),*\s+(\w+)/
        # sms: "111111, BANDG, 30mg, 50, ACCRA"
        data = body.match /(\d{6}),*\s+(\w+),*\s+(\d+)(\w+),*\s+(\d+),*\s+(\w+)/
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
      elsif body.match /(\d{6}),*\s+(\w+),*\s+(\d+),*\s+(\w+)/  
        # sms: "111111, BANDG, 50, ACCRA"
        data = body.match /(\d{6}),*\s+(\w+),*\s+(\d+),*\s+(\w+)/
        data = { 
          :phone        => reply_to,
          :pcvid        => data[1],
          :shortcode    => data[2],
          :qty          => data[3],
          :loc          => data[4],
        }
        sms = SMS.new data
      elsif body.match /([lL]\w+)\?/  
        # sms: "list?"
        data = body.match /([lL]\w+)\?/
        data = {
          :from => '+17322301185',
          :to   => reply_to,
          :body => %w(meds units countryX).join("/n")
        }
        sms = SMS.new data, true
      elsif body.match /([lL]\w+)\s(\w+)/  
        # sms: ["list meds", "list units", "list ghana"]
        data = body.match /([lL]\w+)\s(\w+)/
        if data[2] == "meds" 
          # this will be well over 160 chars.
          # future implementation: add a filter or 
          # send multiple messages
        elsif data[2] == "units"
          # future implementation: add a filter
          data = {
            :from => '+17322301185',
            :to   => reply_to,
            :body => "mg, g, ml"
          }
          sms = SMS.new data, true
        else
          country   = Country.where( :name => data[2], :limit => 1 )
          locations = %w(one two three) #country.pc_hubs.all
          data = {
            :from => '+17322301185',
            :to   => reply_to,
            :body => locations.join(", ")
          }
          sms = SMS.new data, true
        end
      else
        raise "Bad Request" # not a well-formed sms
      end
      sms
    else
      raise "Bad Request" # nil sms

    end
  end

  def self.send_from_order order
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => order.phone,
        :body => order.confirmation_message
    )
  end

  def self.send_error sms, message
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => sms.data[:phone],
        :body => message
    )
  end

end