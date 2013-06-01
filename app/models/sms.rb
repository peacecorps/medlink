class SMS

  def initialize( data )
    @data = data
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
        data = body.match /(\d{6}),*\s+(\w+),*\s+(\d+)(\w+),*\s+(\d+),*\s+(\w+)/
        # sms: "111111, BANDG, 30mg, 50, ACCRA"
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
        data = body.match /(\d{6}),*\s+(\w+),*\s+(\d+),*\s+(\w+)/
        # sms: "111111, BANDG, 50, ACCRA"
        data = { 
          :phone        => reply_to,
          :pcvid        => data[1],
          :shortcode    => data[2],
          :qty          => data[3],
          :loc          => data[4],
        }
        sms = SMS.new data
      elsif body.match /([lL]\w+)\?/
        data = body.match /([lL]\w+)\?/
        # sms: "list?"
        # send 
        data = {
          :from => '+17322301185',
          :to   => reply_to,
          :body => "meds, units, countryX"
        }
        sms = SMS.new data
        sms.send_now true
      elsif body.match /([lL]\w+)\s(\w+)/
        data = body.match /([lL]\w+)\s(\w+)/
        puts data[2]
        # sms: ["list meds", "list units", "list ghana"]
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
          sms = SMS.new data
          sms.send_now true
        else
          # s
          country   = Country.where( :name => data[2], :limit => 1 )
          locations = %w(one two three) #country.pc_hubs.all
          data = {
            :from => '+17322301185',
            :to   => reply_to,
            :body => locations.join(", ")
          }
          sms = SMS.new data
          sms.send_now true
        end
      else
        # not a well-formed sms
        raise "Bad Request"
      end
      sms
    else
      # null sms
      raise "Bad Request"
    end
  end

  def self.send_from_request request
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => request.from,
        :body => request.confirmation_message
    )
    request.confirm! if request.valid?
  end
end