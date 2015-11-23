FactoryGirl.define do
  factory :response do
    user
    country { user.country }
  end
end
