require "rails_helper"

describe SMS::Receiver do
  Given(:twilio)   { TwilioAccount.first! }
  Given(:phone)    { FactoryGirl.create :phone }
  Given(:receiver) { SMS::Receiver.new sid: twilio.sid, to: twilio.number }

  context "with a message", :vcr do
    When(:result) { receiver.handle from: phone.number, body: "got it" }

    Then { result == SMS.outgoing.last                         }
    And  { result.text =~ /can't find any outstanding orders/i }
  end

  context "with an empty message", :vcr do
    When(:result) { receiver.handle from: phone.number, body: "" }

    Then { result == SMS.outgoing.last }
    And  { result.text =~ /resubmit/i  }
  end
end
