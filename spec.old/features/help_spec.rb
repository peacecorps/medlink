require 'spec_helper'

describe "Help page" do
  it "can be visited by anyone" do
    visit help_path
    expect( page ).to have_content "Ordering Supplies"
    expect( page ).to have_content "your assigned SMS contact number"
  end

  it "sees its contact number when logged in" do
    pcv = create :pcv
    login pcv
    visit help_path
    expect( page ).to have_content pcv.sms_contact_number
  end

  it "has special content for pcmos" do
    pcmo = create :pcmo
    login pcmo
    visit help_path
    expect( page ).to have_content "Processing Volunteer Orders"
  end
end
