require 'rails_helper'

RSpec.describe UserTexter do
  Given(:noop) { ->(_) { nil } }

  context "user with one phone" do
    Given(:phone) { FactoryGirl.create :phone }
    When(:result) { UserTexter.new(phone: phone, deliverer: noop).send "hello" }

    Then { result == SMS.outgoing.newest }
    And  { SMS.outgoing.count == 1       }
    And  { result.user == phone.user     }
    And  { result.text == "hello"        }
  end

  context "user with multiple phones" do
    Given(:user) { FactoryGirl.create :user }
    Given!(:p1)  { FactoryGirl.create :phone, user: user }
    Given!(:p2)  { FactoryGirl.create :phone, user: user }

    context "- first phone" do
      When(:result) { UserTexter.new(phone: p1, deliverer: noop).send "boop" }

      Then { result == SMS.outgoing.newest }
      And  { SMS.outgoing.count == 1       }
      And  { result.user == user           }
      And  { result.number == p1.condensed }
    end

    context "- second phone" do
      When(:result) { UserTexter.new(phone: p2, deliverer: noop).send "boop" }

      Then { SMS.outgoing.newest == result }
      And  { SMS.outgoing.count == 1       }
      And  { result.user == user           }
      And  { result.number == p2.condensed }
    end

    context "duplicating messages" do
      Given(:dup) { UserTexter.new(phone: p1, deliverer: noop).send "dup" }

      When(:result) { UserTexter.new(phone: p2, deliverer: noop).send dup.text }

      Then { result == false            }
      And  { SMS.outgoing.count  == 1   }
      And  { SMS.outgoing.newest == dup }
    end
  end

  context "invalid phones are recorded" do
    Given(:deliverer) { ->(_) { raise Twilio::REST::RequestError, "Invalid number" } }
    Given(:phone)     { FactoryGirl.create :phone }

    When(:result) { UserTexter.new(phone: phone, deliverer: deliverer).send "ack" }

    Then { result == SMS.outgoing.newest               }
    And  { SMS.outgoing.count == 1                     }
    And  { result.user == phone.user                   }
    And  { result.number == phone.condensed            }
    And  { result.send_error == "Invalid number"       }
    And  { phone.reload.send_error == "Invalid number" }
  end

  context "phone number with no user" do
    Given(:phone)  { FactoryGirl.create :phone, user: nil }
    Given(:twilio) { TwilioAccount.first! }

    When(:result) { UserTexter.new(phone: phone, deliverer: noop).send "asdf" }

    Then { result == SMS.outgoing.newest    }
    And  { SMS.outgoing.count == 1          }
    And  { result.phone == phone            }
    And  { result.number == phone.condensed }
    And  { result.user == nil               }
    And  { result.twilio_account == twilio  }
  end

  context "repeated text to a number" do
    Given(:phone)     { FactoryGirl.create :phone, user: nil }
    Given(:texter)    { UserTexter.new(phone: phone, deliverer: noop) }
    Given!(:previous) { texter.send "spam" }

    When(:result) { texter.send "spam" }

    Then { result == false }
    And  { texter.spammy? "spam" }
  end

  context "spamming a user" do
    Given(:phone)  { FactoryGirl.create :phone }
    Given(:texter) { UserTexter.new(phone: phone, deliverer: noop) }

    When { texter.send "a" }
    When { texter.send "b" }
    When { texter.send "c" }
    When { texter.send "d" }

    Then { pingbot.messages.last =~ /4 messages/ }
  end
end
