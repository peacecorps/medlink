require "rails_helper"

RSpec.describe TwilioController do
  Given(:twilio) { TwilioAccount.first }
  Given(:phone)  { create :phone }

  context "with a valid sid" do
    When { post :receive, params: { AccountSid: twilio.sid, From: phone.number, To: twilio.number, Body: "help" } }

    Then { status == 200                                            }
    And  { SMS.outgoing.count == 1                                  }
    And  { SMS.outgoing.last.number == Phone.condense(phone.number) }
  end

  context "with a new phone number" do
    Given(:number) { "+1 (555) 555-0123" }

    When { post :receive, params: { AccountSid: twilio.sid, From: number, To: twilio.number, Body: "help" } }

    Then { status == 200                                      }
    And  { SMS.outgoing.count == 1                            }
    And  { SMS.outgoing.last.number == Phone.condense(number) }
  end

  context "with an invalid sid" do
    When { post :receive, params: { AccountSid: "1234", From: phone.number, To: twilio.number, Body: "help" } }

    Then { status == 400           }
    And  { SMS.outgoing.count == 0 }
  end
end
