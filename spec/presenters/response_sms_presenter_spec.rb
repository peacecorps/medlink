require "rails_helper"

RSpec.describe ResponseSMSPresenter do
  Invariant { result.length <= 160                                  }
  Invariant { response.supplies.find { |s| result.include? s.name } }

  context "with all deliveries" do
    Given(:response) { FactoryGirl.create :response, with_methods: [:delivery, :delivery] }

    When(:result) { ResponseSMSPresenter.new(response).instructions }

    Then { result =~ /approved for delivery/ }
  end

  context "with all reimburses" do
    Given(:response) { FactoryGirl.create :response, with_methods: [:purchase, :purchase] }

    When(:result) { ResponseSMSPresenter.new(response).instructions }

    Then { result =~ /Please purchase and allow us to reimburse/ }
  end

  context "with all denied" do
    Given(:response) { FactoryGirl.create :response, with_methods: [:denial, :denial] }

    When(:result) { ResponseSMSPresenter.new(response).instructions }

    Then { result =~ /unable to fulfill your request/ }
  end

  context "with mixed approval" do
    Given(:response) { FactoryGirl.create :response, with_methods: [:delivery, :pickup] }

    When(:result) { ResponseSMSPresenter.new(response).instructions }

    Then { result =~ /has been approved. Check email for details./ }
  end

  context "with partial denial" do
    Given(:response) { FactoryGirl.create :response, with_methods: [:denial, :delivery] }

    When(:result) { ResponseSMSPresenter.new(response).instructions }

    Then { result =~ /unable to fill your entire order/ }
  end
end
