require "rails_helper"

RSpec.describe Notification::SmsHelpNeeded do
  When(:note) { described_class.new sms: sms }

  context "without a user" do
    Given(:sms) { build :sms, user: nil }

    Then { note.text.include?  sms.phone.number }
    And  { note.slack.include? sms.phone.number }
  end

  context "with a user" do
    Given(:sms) { build :sms, user: build(:user, id: rand) }

    Then { note.text.include?  sms.user.email }
    And  { note.slack.include? sms.user.email }
  end
end
