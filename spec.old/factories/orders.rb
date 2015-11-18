FactoryGirl.define do
  factory :order do
    user
    supply
    request { create :request, user: user }
    country { user.country }
  end
end
