FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "Country #{n}"}
  end
end
