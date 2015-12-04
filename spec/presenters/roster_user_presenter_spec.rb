require "rails_helper"

RSpec.describe RosterUserPresenter do
  context "pcv" do
    Given(:user) { FactoryGirl.build :pcv }
    When(:result) { RosterUserPresenter.new user }
    Then { result.role.starts_with? "PCV #" }
  end

  context "pcmo" do
    Given(:user) { FactoryGirl.build :pcmo }
    When(:result) { RosterUserPresenter.new user }
    Then { result.role.starts_with? "PCMO" }
  end

  context "admin" do
    Given(:user) { FactoryGirl.build :admin }
    When(:result) { RosterUserPresenter.new user }
    Then { result.role.starts_with? "Admin" }
  end
end
