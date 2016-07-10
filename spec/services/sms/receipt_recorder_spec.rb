require "rails_helper"

RSpec.describe SMS::ReceiptRecorder do
  Given(:volunteer) { create :pcv }
  Given(:phone)     { create :phone, user: volunteer }
  Given(:response)  { create :response, order_count: 2, user: volunteer }
  Given!(:reminder) { create :receipt_reminder, response: response }
  Given(:handler)   { SMS::ReceiptRecorder.new sms: sms }

  Invariant { handler.valid? }

  When(:result) { handler.run! }

  context "acknowledging a response" do
    Given(:sms) { build :sms, user: volunteer, text: "Got it!" }

    Then { result =~ /your orders for.*marked as received/i }
    And  { response.reload.received?                        }
  end

  context "using more words" do
    Given(:sms) { build :sms, user: volunteer, text: "Yes, thanks!" }

    Then { result =~ /your orders for.*marked as received/i }
    And  { response.reload.received?                        }
  end

  context "flagging a response" do
    Given(:sms) { build :sms, user: volunteer, text: "Nope :(" }

    Then { result =~ /your orders for.*flagged for follow/i }
    And  { response.reload.flagged?                         }
  end

  context "with no outstanding responses" do
    Given(:sms)     { build :sms, user: volunteer, text: "Got it!" }
    Given!(:update) { response.update! received_at: 2.hours.ago }

    Then { result =~ /your orders for.*marked as received/i }
    And  { response.reload.received?                        }
  end

  context "double confirming" do
    Given(:sms)     { build :sms, user: volunteer, text: "flag" }
    Given!(:update) { response.update! received_at: 2.hours.ago }

    Then { result =~ /your orders for.*flagged/i }
    And  { response.reload.flagged?              }
  end

  context "with unknown user" do
    Given(:sms) { build :sms, user: nil, text: "Yes, thanks!" }

    Then { result ==  Failure(SMS::Handler::PresentableError,
                              /can't find user account/i) }
    And  { !response.reload.received? }
  end

  context "with no orders" do
    Given(:sms) { build :sms, user: create(:user), text: "Yes, thanks!" }

    Then { result ==  Failure(SMS::Handler::PresentableError,
                              /can't find any outstanding orders/i) }
    And  { !response.reload.received? }
  end
end
