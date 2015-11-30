require "rails_helper"

RSpec.describe CountrySuppliesPresenter do
  Given(:country) { CountrySuppliesPresenter.new Country.random }

  context "with an available supply" do
    When(:result) { country.supplies.first }

    Then { result.available?                      }
    And  { result.name.starts_with? "<span>"      }
    And  { result.toggle_button.include? "remove" }
  end

  context "with an unavailable supply" do
    Given!(:supply) { FactoryGirl.create :supply }

    When(:result) { country.supplies.find { |s| s.id == supply.id } }

    Then { !result.available?                 }
    And  { result.name.starts_with? "<s>"     }
    And  { result.toggle_button.include? "ok" }
  end
end
