require 'rails_helper'

describe UserTexter do
  Given(:noop) { ->(m) { nil } }

  context "user with a phone" do
    Given(:phone) { FactoryGirl.create :phone }
    When(:result) { UserTexter.new(user: phone.user, deliverer: noop).send "hello" }

    Then { SMS.outgoing.newest == result }
    And  { SMS.outgoing.count == 1       }
    And  { result.user == phone.user     }
    And  { result.text == "hello"        }
  end

  context "user without a phone" do
    Given(:user) { FactoryGirl.create :user }
    When(:result) { UserTexter.new(user: user, deliverer: noop).send "ping" }

    Then { result == false         }
    And  { SMS.outgoing.count == 0 }
  end

  context "user with multiple phones" do
    Given(:user) { FactoryGirl.create :user }
    Given!(:p1)  { FactoryGirl.create :phone, user: user }
    Given!(:p2)  { FactoryGirl.create :phone, user: user }

    context "texting directly" do
      When(:result) { UserTexter.new(user: user, deliverer: noop).send "boop" }

      Then { SMS.outgoing.newest == result }
      And  { SMS.outgoing.count == 1       }
      And  { result.user == user           }
      And  { result.number == p1.condensed }
    end

    context "texting the secondary phone" do
      When(:result) { UserTexter.new(number: p2.number, deliverer: noop).send "boop" }

      Then { SMS.outgoing.newest == result }
      And  { SMS.outgoing.count == 1       }
      And  { result.user == user           }
      And  { result.number == p2.condensed }
    end

    context "duplicating messages"
  end

  context "invalid phones are recorded" do
    Given(:deliverer) { ->(m) { raise Twilio::REST::RequestError, "Invalid number" } }
    Given(:phone)     { FactoryGirl.create :phone }

    When(:result) { UserTexter.new(number: phone.number, deliverer: deliverer).send "ack" }

    # FIXME: should record the error on the SMS object
    # FIXME: should _not_ count SMSs that errored for spam checks
    Then { SMS.outgoing.newest == result               }
    And  { SMS.outgoing.count == 1                     }
    And  { result.user == phone.user                   }
    And  { result.number == phone.condensed            }
    And  { phone.reload.send_error == "Invalid number" }
  end

  context "phone number with no user" do
    Given(:number)  { "+15550000001" }
    Given!(:twilio) { FactoryGirl.create :twilio_account }
    When(:result) { UserTexter.new(number: number, deliverer: noop).send "asdf" }

    Then { SMS.outgoing.newest == result   }
    And  { SMS.outgoing.count == 1         }
    And  { result.user == nil              }
    And  { result.twilio_account == twilio }
    And  { result.number == number         }
  end

  context "repeated text to a number" do
    Given!(:twilio)   { FactoryGirl.create :twilio_account }
    Given(:number)    { "+15551112222" }
    Given(:texter)    { UserTexter.new(number: number, deliverer: noop) }
    Given!(:previous) { texter.send "spam" }

    When(:result) { texter.send "spam" }

    Then { result == false }
    And  { texter.spammy? "spam" }
  end
end
