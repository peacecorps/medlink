FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "#{n}istan" }
    time_zone       { ActiveSupport::TimeZone.all.sample.name }
    twilio_account
  end
end
