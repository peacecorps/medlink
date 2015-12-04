require "rails_helper"

RSpec.describe MessageSearch do
  Given(:p1) { FactoryGirl.create :phone }
  Given(:p2) { FactoryGirl.create :phone }

  Given(:admin) { FactoryGirl.create :admin }
  Given(:pcmo)  { FactoryGirl.create :pcmo, country: p2.user.country }

  Given!(:invalid) { FactoryGirl.create :sms, direction: :incoming, phone: p1 }
  Given!(:valid)   { FactoryGirl.create :sms, direction: :incoming, phone: p2 }
  Given!(:request) { FactoryGirl.create :request, message: valid }
  Given!(:out1)    { FactoryGirl.create :sms, direction: :outgoing, phone: p1 }
  Given!(:out2)    { FactoryGirl.create :sms, direction: :outgoing, phone: p2 }

  context "choice selections" do
    When(:result) { MessageSearch.new(user: admin) }

    Then { result.country_choices.count == Country.count          }
    And  { result.direction_choices == %i(incoming outgoing both) }
    And  { result.validity_choices == %i(valid invalid both)      }
  end

  context "all invalid" do
    When(:result) { MessageSearch.new(user: admin, validity: :invalid).messages }

    Then { result == [invalid] }
  end

  context "valid" do
    When(:result) { MessageSearch.new(user: admin, validity: :valid).messages }

    Then { result == [valid] }
  end

  context "outgoing for pcmo" do
    When(:result) { MessageSearch.new(user: pcmo, direction: :outgoing).messages }

    Then { result == [out2] }
  end

  context "by country" do
    When(:result) { MessageSearch.new(user: admin, direction: :both, country_ids: [p1.user.country_id]).messages }

    Then { result.to_a.sort_by(&:id) == [invalid, out1] }
  end
end
