FactoryGirl.define do
  factory :sms, class: SMS do
    twilio_account
    phone
    number    { phone.condensed }
    text      "hello world"
    direction :incoming
  end
end
