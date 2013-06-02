FactoryGirl.define do
  factory :user do
    sequence(:email)   {|n| "user#{n}@example.com"}
    password 'password'
    phone    '555-867-5309'
    country { FactoryGirl.create(:country) }

    factory :admin do
      role 'admin'
    end
  end
end
