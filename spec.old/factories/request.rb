FactoryGirl.define do
  factory :request do
    user
    sequence(:text) { |n| "Request text #{n}" }
    country { user.country }
  end
end
