require "rails_helper"

describe "Ordering via the web", :queue_jobs do
  Given(:volunteer) { FactoryGirl.create :pcv }
  Given(:pcmo)      { FactoryGirl.create :pcmo, country: volunteer.country }

  it "runs end-to-end", :js, bullet: false do # N.b. the :vcr tag doesn't work because this forks(?)
    # Volunteer makes request
    login_as volunteer

    chosen_request_box = page.find :xpath, "//input[@value='Select Some Options']"
    chosen_request_box.native.send_keys "acet", :Enter
    chosen_request_box.native.send_keys "suns", :Enter
    fill_in "Special Instructions", with: "Pls"
    click_on "Submit"

    request = volunteer.requests.last
    expect(request.text).to eq "Pls"
    expect(request.supplies.map &:name).to eq %w(Acetaminophen Sunscreen)
    expect(page).to have_content "Your order has been sent"
    expect(page).to have_content "Pls"


    # PCMO approves it
    login_as pcmo

    find(".link.order", text: "Sunscreen").click
    find("th.delivery-method", text: "Delivery").click
    fill_in "response_extra_text", with: "Ok!"
    click_on "Send Response"

    expect(page).to have_content "Your response has been sent"
    expect(queued(ActionMailer::DeliveryJob).count).to eq 1

    skip "user indicates receipt of supplies"
    skip "PCMO sees supplies received"
  end

  it "re-displays request form with validation failures" do
    login_as volunteer

    click_on "Submit"
    expect(page).to have_css ".has-error"
  end

  it "doesn't allow volunteers to approve" do
    login_as volunteer

    visit new_user_response_path(volunteer)
    expect(page).to have_content "Not Authorized"
  end
end
