FactoryGirl.define do
  factory :user do
    country                { Country.random }
    sequence(:email)       { |n| "user#{n}@example.com" }
    sequence(:pcv_id)      { |n| n }
    # Keep devise from sending email on each create. smh.
    confirmed_at           { rand(2..365).days.ago }
    time_zone              { ActiveSupport::TimeZone.all.sample.name }
    password               "password"
    first_name             "A"
    last_name              "Person"
    location               "A place"
    secret_key             "mellon"
    welcome_video_shown_at 1.days.ago
    role                   :pcv

    transient do
      order_count 0
      phone_count 0
    end

    trait :textable do
      after :create do |user|
        create :phone, user: user
      end
    end

    trait :unconfirmed do
      confirmed_at nil
    end

    after :create do |user, evaluator|
      create_list :order, evaluator.order_count, user: user
      create_list :phone, evaluator.phone_count, user: user
    end

    User.roles.each do |role_name, _|
      factory role_name.to_sym do
        role role_name
      end
    end
  end
end
