require 'factory_girl'

FactoryGirl.define do
  factory :user do
    email    'user@example.com'
    password 'password'
  end

  factory :supply do
  end

  factory :request do
  end
end