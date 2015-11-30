require "rails_helper"

RSpec.describe ReceiptAckPrompt do
  Given(:bob)    { FactoryGirl.create :pcv, :textable }
  Given(:prompt) { ReceiptAckPrompt.new response }

  context "sends a reminder text" do
    Given(:response) { FactoryGirl.create :response, user: bob, delivery_count: 1, created_at: 15.days.ago }

    When(:result) { prompt.send }

    Then { result == SMS.outgoing.last                            }
    And  { result.user == response.user                           }
    And  { result.text.include? response.supplies.first.shortcode }
  end

  context "skips brand new responses" do
    Given(:response) { FactoryGirl.create :response, user: bob, delivery_count: 1, created_at: 6.hours.ago }

    When(:result) { prompt.send }

    Then { result == nil         }
    And  { !SMS.outgoing.exists? }
  end

  context "skips recently prompted responses" do
    Given(:response)  { FactoryGirl.create :response, user: bob, delivery_count: 1, created_at: 14.days.ago }
    Given!(:reminder) { FactoryGirl.create :receipt_reminder, response: response, created_at: 12.hours.ago  }

    When(:result) { prompt.send }

    Then { result == nil         }
    And  { !SMS.outgoing.exists? }
  end

  context "marks flagged after too many tries" do
    Given(:response) { FactoryGirl.create :response, user: bob, delivery_count: 1, created_at: 14.days.ago }

    When { [9,6,3].each { |n| FactoryGirl.create :receipt_reminder, response: response, created_at: n.days.ago  } }
    When(:result) { prompt.send }

    Then { result == nil                   }
    And  { !SMS.outgoing.exists?           }
    And  { response.flagged?               }
    And  { pingbot.last.include? "Flagged" }
  end

  context "skips orders with no delivered supplies" do
    Given(:response) { FactoryGirl.create :response, user: bob, delivery_count: 0, created_at: 14.days.ago }

    When(:result) { prompt.send }

    Then { result == nil         }
    And  { !SMS.outgoing.exists? }
  end

  context "skips flagged responses" do
    Given(:response) { FactoryGirl.create :response, user: bob, delivery_count: 1, flagged: true, created_at: 14.days.ago }

    When(:result) { prompt.send }

    Then { result == nil         }
    And  { !SMS.outgoing.exists? }
  end

  context "skips received responses" do
    Given(:response) { FactoryGirl.create :response, user: bob, delivery_count: 1, created_at: 14.days.ago, received_at: 5.days.ago }

    When(:result) { prompt.send }

    Then { result == nil         }
    And  { !SMS.outgoing.exists? }
  end
end
