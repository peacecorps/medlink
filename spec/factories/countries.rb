# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country do
    sequence(:name) {|n| "CoolCountry#{n}"}
  end
end
