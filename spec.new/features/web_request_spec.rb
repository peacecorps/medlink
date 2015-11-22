require "rails_helper"

describe "Ordering via the web" do
  it "runs end-to-end", :js do # N.b. the :vcr tag doesn't work because this forks(?)
    phone     = FactoryGirl.create :phone
    volunteer = phone.user
    country   = volunteer.country
    twilio    = country.twilio_account
    supplies  = country.supplies.random 3

    volunteer.update! welcome_video_shown_at: 1.day.ago, password: "password"

    # User orders some supplies
    visit root_path
    within ".sign-in" do
      fill_in "Email", with: volunteer.email
      fill_in "Password", with: "password"
      click_on "Sign In"
    end

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
end
