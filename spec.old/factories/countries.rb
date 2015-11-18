FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "Country #{n}"}
    time_zone       { ActiveSupport::TimeZone.all.sample.name }
    twilio_account
  end
end
