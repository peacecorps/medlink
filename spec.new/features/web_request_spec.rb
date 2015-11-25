require "rails_helper"

describe "Ordering via the web" do
  Given(:volunteer) { FactoryGirl.create :pcv }

  it "runs end-to-end", :js do # N.b. the :vcr tag doesn't work because this forks(?)
    login_as volunteer

    chosen_request_box = page.find :xpath, "//input[@value='Select Some Options']"
    chosen_request_box.native.send_keys "acet", :Enter
    chosen_request_box.native.send_keys "suns", :Enter
    fill_in "Special Instructions", with: "Pls"
    click_on "Submit"

    request = volunteer.requests.last
    expect(request.text).to eq "Pls"
    expect(request.supplies.map &:name).to eq %w(Acetaminophen Sunscreen)

    skip "user can see orders in their timeline"

    skip "PCMO responds to orders"
    skip "user indicates receipt of supplies"
    skip "PCMO sees supplies received"
  end

  it "re-displays request form with validation failures" do
    login_as volunteer

    click_on "Submit"
    expect(page).to have_css ".has-error"
  end
end
