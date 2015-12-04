require "spec_helper"

RSpec.describe SMS::Condenser do
  context "with a very long template" do
    Given(:country)  { "x" * 180 }
    Given(:codes) { %w(foo bar baz) * 20 }

    When(:result) { SMS::Condenser.new("sms.invalid_for_country", :code, codes: codes, country: country).message }

    Then { (160 .. 320).cover? result.length }
    And  { result.include? "59"              }
  end
end
