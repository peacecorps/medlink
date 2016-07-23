require "rails_helper"

RSpec.describe Notification::UnrecognizedSMS do
  Given(:sms) { build :sms, id: rand, phone: build(:phone), user: user }

  When(:note) { described_class.new sms: sms }

  context "without a user" do
    Given(:user) { nil }

    Then { note.text.include?   sms.id.to_s      }
    And  { note.text.include?   sms.phone.number }
    And  { note.text.include?   sms.text         }
    And  { note.slack.include?  sms.id.to_s      }
    And  { note.slack.include?  sms.phone.number }
    And  { note.slack.include?  sms.text         }
  end

  context "with a user" do
    Given(:user) { build :user, id: rand }

    Then { note.text.include?   sms.id.to_s      }
    And  { note.text.include?   sms.user.email   }
    And  { note.text.include?   sms.text         }
    And  { note.slack.include?  sms.id.to_s      }
    And  { note.slack.include?  sms.user.email   }
    And  { note.slack.include?  sms.text         }
  end
end
