FactoryGirl.define do
  factory :order do
    request
    user            { request.user }
    country         { user.country }
    supply          { Supply.random }
    delivery_method { response ? DeliveryMethod.to_a.sample : nil }
  end
end
