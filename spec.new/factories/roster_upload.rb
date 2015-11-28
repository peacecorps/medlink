FactoryGirl.define do
  factory :roster_upload do
    uploader { create :admin }
  end
end
