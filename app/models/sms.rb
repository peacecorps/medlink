class SMS
  def parse params
    raise "Not Implemented"
  end

  def send_confirmation request
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
    client.account.sms.messages.create(
        :from => '+17322301185',
        :to   => request.from,
        :body => request.confirmation_message
    )
    request.confirm! if request.valid?
  end
end