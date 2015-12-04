require "spec_helper"

RSpec.describe Phone do
  Given!(:phone) { Phone.for number: "+1 (234) 567-8900" }

  context "finding with original number" do
    When(:result) { Phone.for number: "+1 (234) 567-8900" }
    Then { result == phone }
  end

  context "finding with condensed number" do
    When(:result) { Phone.for number: "12345678900" }
    Then { result == phone }
  end

  context "finding with some random garbage" do
    When(:result) { Phone.for number: "1  234.567.8900" }
    Then { result == phone }
  end

  context "processing a new number" do
    When(:result) { Phone.for number: "+55 (555) 555-5555" }
    Then { result.persisted? }
    And  { result != phone   }
  end

  context "creating a malformed number" do
    # TODO: do we actually need this? Or should we automatically add + / check the number?
    When(:result) { Phone.create! number: "1234" }
    Then { result == Failure(ActiveRecord::RecordInvalid, /country code/i) }
  end

  context "when changing number" do
    When(:result) { phone.update! number: "+999" }
    Then { result == Failure(ActiveRecord::RecordInvalid, /immutable/i) }
  end
end
