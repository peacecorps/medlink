require "rails_helper"

RSpec.describe ReceiptTracker do
  Given(:response)  { FactoryGirl.build :response }
  Given(:volunteer) { response.user }
  Given(:pcmo)      { FactoryGirl.create :pcmo, country: volunteer.country }
  Given(:other)     { FactoryGirl.create :pcv, country: response.country }

  context "pcv marking receipt" do
    Given(:tracker) { ReceiptTracker.new response: response, approver: volunteer }

    When(:result) { tracker.acknowledge_receipt }

    Then { result == true                        }
    And  { response.received?                    }
    And  { response.received_by == response.user }
    And  { !response.flagged?                    }
  end

  context "pcmo marking receipt" do
    Given(:tracker) { ReceiptTracker.new response: response, approver: pcmo }

    When(:result) { tracker.acknowledge_receipt }

    Then { result == true                }
    And  { response.received?            }
    And  { response.received_by == pcmo  }
    And  { !response.flagged?            }
  end

  context "can't mark others' responses" do
    Given(:tracker) { ReceiptTracker.new response: response, approver: other }

    When(:result) { tracker.acknowledge_receipt }

    Then { result == Failure(Pundit::NotAuthorizedError) }
    And  { !response.received?                           }
    And  { !response.flagged?                            }
  end

  context "it can flag for follow up" do
    Given(:tracker) { ReceiptTracker.new response: response, approver: volunteer }

    When(:result) { tracker.flag_for_follow_up }

    Then { result == true      }
    And  { response.flagged?   }
    And  { !response.received? }
  end

  context "it can re-order a lost response" do
    Given(:tracker) { ReceiptTracker.new response: response, approver: pcmo }

    When { response.save! }
    When(:result) { tracker.reorder }

    Then { result == true                                                }
    And  { response.replacement                                          }
    And  { response.replacement.supplies == response.supplies            }
    And  { volunteer.last_requested_at = response.replacement.created_at }
    And  { response.cancelled_at.present?                                }
  end
end
