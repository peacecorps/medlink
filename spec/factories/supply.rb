FactoryGirl.define do
  factory :supply do
    sequence(:name) { |n| "Supply#{n}" }
    sequence(:shortcode) { |n| "s#{n}" }
  end
end
