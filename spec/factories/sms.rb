FactoryGirl.define do
  factory :sms, class: SMS do
    twilio_account
    phone
    user      { phone.user }
    number    { phone.condensed }
    text      "hello world"
    direction :incoming
  end
end
