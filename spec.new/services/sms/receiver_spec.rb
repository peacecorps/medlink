require "rails_helper"

describe SMS::Receiver do
  Given(:twilio)   { TwilioAccount.first! }
  Given(:phone)    { FactoryGirl.create :phone }
  Given(:receiver) { SMS::Receiver.new sid: twilio.sid, to: twilio.number }

  When(:result) { receiver.handle from: phone.number, body: "got it" }

  Then { SMS.outgoing.last.text =~ /can't find any outstanding orders/i }
end
