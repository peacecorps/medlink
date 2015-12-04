require "rails_helper"

RSpec.describe SMS::ReceiptRecorder do
  Given(:volunteer) { FactoryGirl.create :pcv }
  Given(:phone)     { FactoryGirl.create :phone, user: volunteer }
  Given(:response)  { FactoryGirl.create :response, order_count: 2, user: volunteer }
  Given!(:reminder) { FactoryGirl.create :receipt_reminder, response: response }

  Invariant { handler.valid? }

  context "acknowledging a response" do
    Given(:sms)     { FactoryGirl.build :sms, user: volunteer, text: "Got it!" }
    Given(:handler) { SMS::ReceiptRecorder.new sms: sms }

    When(:result) { handler.run! }

    Then { result =~ /your orders for.*marked as received/i }
    And  { response.reload.received?                        }
  end

  context "flagging a response" do
    Given(:sms)     { FactoryGirl.build :sms, user: volunteer, text: "Nope :(" }
    Given(:handler) { SMS::ReceiptRecorder.new sms: sms }

    When(:result) { handler.run! }

    Then { result =~ /your orders for.*flagged for follow/i }
    And  { response.reload.flagged?                         }
  end

  context "with no outstanding responses" do
    Given(:sms)     { FactoryGirl.build :sms, user: volunteer, text: "Got it!" }
    Given(:handler) { SMS::ReceiptRecorder.new sms: sms }

    When          { response.update! received_at: 2.hours.ago }
    When(:result) { handler.run! }

    Then { result == Failure(SMS::Handler::PresentableError, /can't find/) }
  end

  context "double confirming" do
    Given(:sms)     { FactoryGirl.build :sms, user: volunteer, text: "flag" }
    Given(:handler) { SMS::ReceiptRecorder.new sms: sms }

    When          { response.update! received_at: 2.hours.ago }
    When(:result) { handler.run! }

    Then { result == Failure(SMS::Handler::PresentableError, /can't find/) }
    And  { !response.reload.flagged?                                       }
  end
end
