FactoryGirl.define do
  factory :order do
    user
    confirmed false
    fulfilled false
  end
end
