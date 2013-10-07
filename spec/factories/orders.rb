FactoryGirl.define do
  factory :order do
    user
    responded_at nil
    fulfilled_at nil
    supply
    dose 1
    unit 'mg'
    quantity 2
    location 'Atlanta'
  end
end
