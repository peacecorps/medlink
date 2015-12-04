FactoryGirl.define do
  factory :request do
    user
    country { user.country }
  end
end
