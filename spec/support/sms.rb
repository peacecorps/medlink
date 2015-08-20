SmsSpec.driver = :"twilio-ruby"

# SmsSpec stubs out Twilio methods, but we still fetch these from the env, so
# they at least need to be present
%w(ACCOUNT_SID AUTH PHONE_NUMBER).each do |k|
  ENV["TWILIO_#{k}"] ||= "xxxxxx"
end

RSpec.configure do |config|
  config.include SmsSpec::Helpers

  helpers = Module.new do
    def send_text user, text
      twilio = user.country.twilio_account
      phone  = user.phones.first || create(:phone, user: user)
      page.driver.post medrequest_path, "From" => phone.number, "Body" => text, "To" => twilio.number, "AccountSid" => twilio.sid
      SMS.outgoing.last
    end
  end
  config.include helpers
end
