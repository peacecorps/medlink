FactoryGirl.define do
  factory :order do
    user
    fulfilled_at nil
    supply
    dose 'mg'
    quantity 2
    location 'Atlanta'
  end
end
