FactoryGirl.define do
  factory :user do
    country           { Country.random }
    sequence(:email)  { |n| "user#{n}@example.com" }
    sequence(:pcv_id) { |n| n }
    confirmed_at      { rand(1..365).days.ago } # Keep devise from sending email on each create. smh.
    password   "password"
    first_name "A"
    last_name  "Person"
    role       :pcv
    time_zone  { ActiveSupport::TimeZone.all.sample.name }
    location   "A place"
    secret_key "mellon"

    User.roles.each do |role_name, _|
      factory role_name.to_sym do
        role role_name
      end
    end
  end
end
