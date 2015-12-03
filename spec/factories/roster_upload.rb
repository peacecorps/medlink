FactoryGirl.define do
  factory :roster_upload do
    uploader { create :admin }
    country  { Country.random }
  end
end
