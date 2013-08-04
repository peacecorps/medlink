FactoryGirl.define do
  factory :supply do
    sequence(:name) { |n| "Supply#{n}" }
  end
end