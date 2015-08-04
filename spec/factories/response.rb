FactoryGirl.define do
  factory :response do
    user
    country { user.country }
    extra_text "Extra response instructions"
  end
end
