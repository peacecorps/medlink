# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    user_id 1
    pc_hub_id 1
    confirmed false
    fulfilled false
    phone "MyString"
    email "MyString"
    extra "MyText"
  end
end
