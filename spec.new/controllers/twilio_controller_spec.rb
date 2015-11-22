require "rails_helper"

describe TwilioController do
  Given(:twilio) { TwilioAccount.first }
  Given(:phone)  { FactoryGirl.create :phone }

  context "with a valid sid", :vcr do
    When(:result) { post :receive, AccountSid: twilio.sid, From: phone.number, To: twilio.number, Body: "help" }

    Then { result.status == 200                                     }
    And  { SMS.outgoing.count == 1                                  }
    And  { SMS.outgoing.last.number == Phone.condense(phone.number) }
  end

  context "with a new phone number", :vcr do
    Given(:number) { "+1 (555) 555-0123" }
    When(:result) { post :receive, AccountSid: twilio.sid, From: number, To: twilio.number, Body: "help" }

    Then { result.status == 200                               }
    And  { SMS.outgoing.count == 1                            }
    And  { SMS.outgoing.last.number == Phone.condense(number) }
  end

  context "with an invalid sid" do
    When(:result) { post :receive, AccountSid: "1234", From: phone.number, To: twilio.number, Body: "help" }

    Then { result.status == 400    }
    And  { SMS.outgoing.count == 0 }
  end
end
