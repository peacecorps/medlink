class Fakerer
  class << self
    def digits n
      n.times.map { rand(0..9).to_s }.join
    end
    def phone
      "+1 (#{digits 3}) #{digits 3}-#{digits 4}"
    end
  end
end

FactoryGirl.define do
  factory :phone do
    number { Fakerer.phone }
  end
end
