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

    Then { !result.reordered? }
  end
end
