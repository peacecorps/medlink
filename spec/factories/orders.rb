FactoryGirl.define do
  factory :order do
    user
    pc_hub
    confirmed false
    fulfilled false
  end
end
