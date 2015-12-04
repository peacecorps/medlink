FactoryGirl.define do
  factory :supply do
    sequence(:name)      { |n| "Supply #{n}"}
    sequence(:shortcode) { |n| "CODE#{n}"   }
  end
end
