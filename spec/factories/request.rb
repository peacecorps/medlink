FactoryGirl.define do
  factory :request do
    supply { FactoryGirl.create(:supply) }
  end
end
