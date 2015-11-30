require "rails_helper"

RSpec.describe SupplyPresenter do
  context "available" do
    Given(:supply) { FactoryGirl.build :supply, id: 1, orderable: true }

    When(:result) { SupplyPresenter.new supply }

    Then { result.name.start_with? "<span>"               }
    And  { result.global_toggle_btn.include? "btn-danger" }
  end

  context "unavailable" do
    Given(:supply) { FactoryGirl.build :supply, id: 1, orderable: false }

    When(:result) { SupplyPresenter.new supply }

    Then { result.name.start_with? "<s>"                   }
    And  { result.global_toggle_btn.include? "btn-default" }
  end
end
