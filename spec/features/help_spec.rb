require 'spec_helper'

describe "Help page" do
  it "can be visited by anyone" do
    visit help_path
    expect( page ).to have_content "Ordering Supplies"
  end

  it "has special content for pcmos" do
    pcmo = create :pcmo
    login pcmo
    visit help_path
    expect( page ).to have_content "Processing Volunteer Orders"
  end
end
