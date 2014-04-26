FactoryGirl.define do
  factory :request do
    user
    sequence(:text) { |n| "Request text #{n}" }
  end
end
