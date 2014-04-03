class SMS
  class Response
    def initialize number, text
      @number, @text = number, text
    end

    def send
      sid, auth = %w(ACCOUNT_SID AUTH).map { |k| ENV.fetch ["TWILIO_#{k}"] }

      SMS.create number: @number, text: @text, direction: :outgoing

      client = Twilio::REST::Client.new sid, auth
      client.account.sms.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to:   @number
        body: @text
      )
    end
  end
end
