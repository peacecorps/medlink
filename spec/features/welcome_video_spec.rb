require "rails_helper"

RSpec.describe "Welcome video" do
  Given(:pcv) { FactoryGirl.create :pcv, welcome_video_shown_at: nil }

  it "shows the welcome video" do
    login_as pcv
    click_on "I've watched this video"

    expect(page).to have_content "Request Form"

    logout
    login_as pcv
    expect(page).to have_content "Request Form"
  end
end
