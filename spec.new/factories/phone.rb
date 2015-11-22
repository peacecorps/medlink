FactoryGirl.define do
  factory :phone do
    sequence(:number) { |n| "+1 (555) 555-#{n.to_s.rjust 4, '7'}" }
    condensed { Phone.condense(number) }
    user
  end
end
