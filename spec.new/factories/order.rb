FactoryGirl.define do
  factory :order do
    request
    user    { request.user }
    country { user.country }
    supply  { Supply.random }
  end
end
