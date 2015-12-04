require "rails_helper"

RSpec.describe PhoneSyncForm do
  Given(:pcv)     { FactoryGirl.create :pcv }
  Given!(:phones) { %w(+1 +2).map { |n| FactoryGirl.create :phone, user: pcv, number: n } }
  Given(:form)    { PhoneSyncForm.new pcv }

  context "swapping out a phone number" do
    When { form.validate(numbers: "+1, +3") && form.save }

    Then { Phone.find_by(condensed: "+1").user == pcv }
    And  { Phone.find_by(condensed: "+2").user == nil }
    And  { Phone.find_by(condensed: "+3").user == pcv }
  end

  context "trying a taken number" do
    Given(:taken) { FactoryGirl.create :phone }

    When(:result) { form.validate(numbers: "+1, +2, #{taken.number}") }

    Then { result == false       }
    And  { pcv.phones.count == 2 }
  end
end
