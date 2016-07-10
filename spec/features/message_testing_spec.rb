require "rails_helper"

RSpec.describe "message testing" do
  it "lets admins try texting on the web" do
    admin = create :admin
    create :phone, user: admin

    login_as admin
    visit tester_messages_path

    fill_in "Message", with: "aceta - extra message"
    click_on "Send"

    expect(page).to have_content "Your request for Acetaminophen (ACETA)"
    expect(page).to have_content "aceta - extra message"
  end
end
