class CountryFetcher
  def self.random
    @_all = Country.all.to_a unless @_all && @_all.any?
    @_all.sample
  end
end

FactoryGirl.define do
  factory :user do
    country           { CountryFetcher.random }
    sequence(:email)  { |n| "user#{n}@example.com" }
    sequence(:pcv_id) { |n| n }
    confirmed_at      { rand(1..365).days.ago } # Keep devise from sending email on each create. smh.
    password   "password"
    first_name "A"
    last_name  "Person"
    role       :pcv
    time_zone  { ActiveSupport::TimeZone.all.sample.name }
    location   "A place"

    User.roles.keys.each do |role_name|
      factory role_name do
        role role_name
      end
    end
  end
end
