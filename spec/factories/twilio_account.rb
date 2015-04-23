FactoryGirl.define do
  factory :twilio_account do
    number { 10.times.map { rand(0..9).to_s }.join "" }
  end
end
