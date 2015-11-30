require 'rails_helper'

RSpec.describe SMS do
  Given(:text)    { "is this thing on?" }
  Given(:number)  { "555" }
  Given!(:old)    { FactoryGirl.create :sms, text: text, number: number, created_at: 1.month.ago }
  Given!(:recent) { FactoryGirl.create :sms, text: text, number: number, created_at: 1.hour.ago  }
  Given!(:other)  { FactoryGirl.create :sms, text: "something else", number: number, created_at: 2.minutes.ago }

  When(:result) { FactoryGirl.create :sms, text: text, number: number }

  Then { result.duplicates.count == 2      }
  And  { result.last_duplicate   == recent }
  And  { result.duplicates(within:  1.day).count == 1 }
  And  { result.duplicates(within: 1.hour).count == 0 }
end
