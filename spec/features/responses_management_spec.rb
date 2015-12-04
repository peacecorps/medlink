require "rails_helper"

RSpec.describe "managing responses" do
  it "lets pcmos track responses" do
    pcmo = FactoryGirl.create :pcmo
    e1, e2, e3, e4 = 4.times.map { FactoryGirl.create(:response, country: pcmo.country).user.email }

    login_as pcmo

    visit responses_path
    find("tr", text: e1).click_on "Received"
    find("tr", text: e2).click_on "Cancel"
    find("tr", text: e3).click_on "Reorder"

    expect(page).not_to have_content e1
    expect(page).not_to have_content e2
    expect(page).not_to have_content e3
    expect(page).to have_content e4

    click_on "Archived"
    expect(page).to have_content e1
    expect(page).to have_content e2
    expect(page).to have_content e3
    expect(page).not_to have_content e4

    click_on "All"
    expect(page).to have_content e1
    expect(page).to have_content e2
    expect(page).to have_content e3
    expect(page).to have_content e4
  end

  it "lets pcvs flag responses" do
    sms      = FactoryGirl.create :sms
    pcv      = sms.user
    response = FactoryGirl.create :response, user: pcv

    login_as pcv
    visit timeline_path

    click_on "Flag for follow-up"
    expect(flash).to have_content "flagged for follow-up from your PCMO"
  end

  it "validates responses are present" do
    pcmo  = FactoryGirl.create :pcmo
    pcv   = FactoryGirl.create :pcv, country: pcmo.country
    order = FactoryGirl.create :order, user: pcv

    login_as pcmo
    visit new_user_response_path pcv
    click_on "Send Response"

    expect(flash).to have_content "No response"
  end

  it "lets pcmos view responses" do
    pcmo     = FactoryGirl.create :pcmo
    response = FactoryGirl.create :response, country: pcmo.country

    login_as pcmo
    visit response_path response
    expect(page).to have_content response.supplies.first.name
  end
end
