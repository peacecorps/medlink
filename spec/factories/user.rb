FactoryGirl.define do
  factory :user do
    sequence(:email)   {|n| "user#{n}@example.com"}
    password 'password'
    phone    '555-867-5309'
    country { FactoryGirl.create(:country) }
    sequence(:first_name) {|n| "user#{n}"}
    sequence(:last_name) {|n| "user#{n}last"}
    sequence(:pcv_id) {|n| n}
    sequence(:city) {|n| "city#{n}"}

    factory :admin do
      role 'admin'
    end
  end
end
