# We'll stub out Twilio methods, but we still fetch these from the env, so
# they at least need to be present
%w(ACCOUNT_SID AUTH PHONE_NUMBER).each do |k|
  ENV["TWILIO_#{k}"] ||= "xxxxxx"
end

SentTwilioMessages = []
class FakeMessage
  attr_reader :number, :body
  def initialize msg
    @number = Phone.condense msg[:to]
    @body   = msg[:body]
  end
end

class Twilio::REST::Messages
  InvalidNumber = "+5551231234"

  def create msg
    if msg[:to] == InvalidNumber
      raise Twilio::REST::RequestError, "#{InvalidNumber} is not a valid number"
    else
      SentTwilioMessages.push FakeMessage.new msg
    end
  end
end



RSpec.configure do |config|
  helpers = Module.new do
    def send_text user, text
      twilio = user.country.twilio_account
      phone  = user.phones.first || create(:phone, user: user)
      page.driver.post medrequest_path, "From" => phone.number, "Body" => text, "To" => twilio.number, "AccountSid" => twilio.sid
      SMS.outgoing.last
    end

    def messages
      SentTwilioMessages
    end
  end
  config.include helpers
end
