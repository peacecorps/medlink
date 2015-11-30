require "rails_helper"

RSpec.describe SmsJob do
  Given(:twilio) { TwilioAccount.random }

  context "without a user" do
    Given(:phone)  { FactoryGirl.create :phone, user: nil }

    When(:result) { SmsJob.new.perform phone: phone, twilio_account: twilio, message: "Hello" }

    Then { result == true                      }
    And  { phone.messages.last.text == "Hello" }
  end

  context "with a user" do
    Given(:phone)  { FactoryGirl.create :phone }

    When(:result) { SmsJob.new.perform phone: phone, twilio_account: twilio, message: "Is it me?" }

    Then { result == true                          }
    And  { phone.messages.last.text == "Is it me?" }
  end
end
