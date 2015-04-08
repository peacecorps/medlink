FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "Country #{n}"}
    twilio_account
  end
end
