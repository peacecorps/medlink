FactoryGirl.define do
  factory :receipt_reminder do
    response
    user    { response.user }
    message { create :sms }
  end
end
