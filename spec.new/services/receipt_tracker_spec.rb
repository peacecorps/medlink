require "rails_helper"

describe ReceiptTracker do
  Given(:response) { FactoryGirl.build :response }
  Given(:tracker)  { ReceiptTracker.new response: response }

  context "pcv marking receipt" do
    When(:result) { tracker.acknowledge_receipt by: response.user }

    Then { result == true                        }
    And  { response.received?                    }
    And  { response.received_by == response.user }
    And  { !response.flagged?                    }
  end

  context "pcmo marking receipt" do
    Given(:pcmo) { FactoryGirl.create :pcmo, country: response.country }

    When(:result) { tracker.acknowledge_receipt by: pcmo }

    Then { result == true                }
    And  { response.received?            }
    And  { response.received_by == pcmo  }
    And  { !response.flagged?            }
  end

  context "can't mark others' responses" do
    Given(:other) { FactoryGirl.create :pcv, country: response.country }

    When(:result) { tracker.acknowledge_receipt by: other }

    Then { result == Failure(Pundit::NotAuthorizedError) }
    And  { !response.received?                           }
    And  { !response.flagged?                            }
  end

  context "it can flag for follow up" do
    When(:result) { tracker.flag_for_follow_up by: response.user }

    Then { result == true      }
    And  { response.flagged?   }
    And  { !response.received? }
  end
end
