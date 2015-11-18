FactoryGirl.define do
  factory :sms, class: SMS do
    text "hello world"
    direction :incoming
    twilio_account
  end
end
