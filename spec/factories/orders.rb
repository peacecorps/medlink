FactoryGirl.define do
  factory :order do
    user
    supply
    request { create :request, user: user }
  end
end
