require "rails_helper"

RSpec.describe RequestPresenter do
  Given(:old) { FactoryGirl.create :response }

  context "when reordered" do
    Given(:request) { FactoryGirl.build :request, reorder_of: old }

    When(:result) { RequestPresenter.new request }

    Then { result.reordered? }
  end

  context "when new" do
    Given(:request) { FactoryGirl.build :request }

    When(:result) { RequestPresenter.new request }

    Then { !result.reordered?          }
    And  { result.text == request.text }
  end

  context "describing reorders" do
    Given(:response) { FactoryGirl.create :response }
    Given(:reorder)  { FactoryGirl.build :request, reorder_of: response }

    When(:result) { RequestPresenter.new reorder }

    Then { result.text.start_with? "Replacement of" }
  end
end
