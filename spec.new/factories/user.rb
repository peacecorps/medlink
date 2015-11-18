FactoryGirl.define do
  factory :user do
    country
    sequence(:email)  { |n| "user#{n}@example.com" }
    sequence(:pcv_id) { |n| n }
    password   "password"
    first_name "A"
    last_name  "Person"
    role       :pcv
    time_zone  { ActiveSupport::TimeZone.all.sample.name }
    location   "A place"
  end
end
