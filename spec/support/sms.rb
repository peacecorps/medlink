SmsSpec.driver = :"twilio-ruby"

# SmsSpec stubs out Twilio methods, but we still fetch these from the env, so
# they at least need to be present
%w(ACCOUNT_SID AUTH PHONE_NUMBER).each do |k|
  ENV["TWILIO_#{k}"] ||= "xxxxxx"
end
