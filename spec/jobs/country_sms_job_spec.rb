require "rails_helper"

RSpec.describe CountrySMSJob, :queue_jobs do
  Given(:twilio)  { TwilioAccount.random }
  Given(:country) { Country.random }
  Given(:message) { "A towel is about the most massively useful thing a volunteer can have" }
  Given!(:pcvs)   { 0.upto(2).map { |n| FactoryGirl.create :pcv, country: country, phone_count: n } }

  When(:result) { CountrySMSJob.new.perform country: country, message: message }

  Then { result == true                    }
  And  { queued(SmsJob).count == 2         }
  And  { slackbot.messages.last =~ /towel/ }
end
