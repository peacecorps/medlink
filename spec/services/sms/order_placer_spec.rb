require "rails_helper"

RSpec.describe SMS::OrderPlacer do
  Given(:volunteer) { FactoryGirl.create :pcv }
  Given(:phone)     { FactoryGirl.create :phone, user: volunteer }
  Given(:supplies)  { volunteer.country.supplies.random(20) }
  Given(:supply)    { supplies.first }

  Invariant { SMS::OrderPlacer.new(sms: sms).valid? }

  context "requires a user" do
    Given(:guest)  { FactoryGirl.create :phone, user: nil }
    Given(:sms)    { FactoryGirl.create :sms, phone: guest, text: "#{supply.shortcode} - please and thank you!" }

    When(:result) { SMS::OrderPlacer.new(sms: sms).run! }

    Then { result == Failure(SMS::Handler::PresentableError, /can't find user account/i) }
  end

  context "can place an order" do
    Given(:sms) { FactoryGirl.create :sms, phone: phone, text: "#{supply.shortcode} - please and thank you!" }

    When(:result) { SMS::OrderPlacer.new(sms: sms).run! }

    Then { result =~ /expect a response/i   }
    And  { result.include? supply.name      }
    And  { result.include? supply.shortcode }

    And  { sms.request.present?                        }
    And  { sms.request.user == volunteer               }
    And  { sms.request.supplies == [supply]            }
    And  { sms.request.text == "please and thank you!" }
  end

  context "duplicate messages" do
    Given(:sms)      { FactoryGirl.create :sms, phone: phone, text: "#{supply.shortcode} - please and thank you!" }
    Given(:repeat)   { sms.dup.tap &:save! }
    Given!(:placer)  { SMS::OrderPlacer.new(sms: sms).run! }
    Given(:replacer) { SMS::OrderPlacer.new(sms: repeat) }

    When(:result) { SMS::OrderPlacer.new(sms: repeat).run! }

    Then { result == Failure(SMS::Handler::PresentableError, /already received your request/i) }
    And  { repeat.request.nil? }
  end

  context "with invalid supplies" do
    Given(:sms) { FactoryGirl.create :sms, phone: phone, text: "ZXCV, ASDF" }

    When(:result) { SMS::OrderPlacer.new(sms: sms).run! }

    Then { result == Failure(SMS::Handler::PresentableError, /unrecognized supply short codes: ZXCV and ASDF/i) }
  end

  context "with unavailable supplies" do
    Given(:requested) { supplies.first 3 }
    Given!(:removed)  { volunteer.country.supplies.delete(requested.sample).first }
    Given(:sms)       { FactoryGirl.create :sms, phone: phone, text: requested.map(&:shortcode).join(" ") }

    When(:result) { SMS::OrderPlacer.new(sms: sms).run! }

    Then { result == Failure(
             SMS::Handler::PresentableError,
             /#{removed.shortcode} are not currently offered.*in #{volunteer.country.name}/) }
  end

  context "can abridge the confirmation message if it's too long" do
    Given(:sms) { FactoryGirl.create :sms, phone: phone, text: supplies.first(12).map(&:shortcode).join(" ") }

    When(:result) { SMS::OrderPlacer.new(sms: sms).run! }

    Then { result.length < 160           }
    And  { result =~ /11 other supplies/ }
  end

  context "test" do
    Given(:other) { FactoryGirl.create :phone }
    Given(:sms)   { FactoryGirl.create :sms, phone: other, text: "@#{volunteer.pcv_id} #{supply.shortcode}" }

    When(:result) { SMS::OrderPlacer.new(sms: sms).run! }

    Then { result.include? supply.shortcode  }
    And  { !result.include? volunteer.pcv_id }
    And  { sms.request.supplies.count == 1   }
  end
end
