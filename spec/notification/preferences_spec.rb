require "rails_helper"

RSpec.describe Notifier::Preferences do
  context "for the system" do
    Given(:prefs) { Notifier::Preferences::System.new }

    context "defaults" do
      Then { prefs.for(Notification::SmsHelpNeeded)   == [Notifier::Strategy::Slack] }
      And  { prefs.for(Notification::SendingResponse) == [Notifier::Strategy::Log  ] }
    end

    context "updating" do
      Given!(:update) { prefs.sms_help_needed = [Notifier::Strategy::Ping] }

      When(:loaded) { Notifier::Preferences::System.new }

      Then { prefs.for(Notification::SmsHelpNeeded)   == [Notifier::Strategy::Ping] }
      And  { prefs.for(Notification::SendingResponse) == [Notifier::Strategy::Log ] }
    end
  end

  context "for users" do
    Given(:user)  { build :pcv, id: rand(1 .. 1000) }
    Given(:prefs) { Notifier::Preferences::User.new user }

    context "defaults" do
      Then { prefs.for(Notification::ResponseCreated) == [Notifier::Strategy::Email, Notifier::Strategy::Text] }
    end

    context "updating" do
      Given!(:update) { prefs.response_created = [Notifier::Strategy::Telegram] }

      When(:loaded) { Notifier::Preferences::User.new user }

      Then { prefs.for(Notification::ResponseCreated) == [Notifier::Strategy::Telegram] }
    end
  end
end
