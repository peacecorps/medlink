FactoryGirl.define do
  factory :twilio_account do
    sid    { rand(1..1_000_000) }
    auth   { SecureRandom.hex(16) }
    number { 10.times.map { rand(0..9).to_s }.join "" }
  end
end
