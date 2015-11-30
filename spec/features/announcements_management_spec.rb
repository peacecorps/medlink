require "rails_helper"

RSpec.describe "managing announcements" do
  it "can do all the CRUD" do
    pcv   = FactoryGirl.create :pcv
    admin = FactoryGirl.create :admin

    login_as admin

    # Create
    visit announcements_path
    click_link "New Announcement"

    select pcv.country.name, from: "Country"
    click_on "Create Announcement"

    field = find ".has-error", text: "Message"
    expect(field).to have_content "can't be blank"

    fill_in "Message", with: "Hello!"
    click_on "Create Announcement"

    expect(page).to have_content "Hello!"

    # Update
    click_on "Edit"
    fill_in "Days", with: "5,-3"
    click_on "Update Announcement"

    field = find ".has-error", text: "Hour"
    expect(field).to have_content "required for scheduled announcements"

    select "09", from: "Hour"
    click_on "Update Announcement"

    expect(page).to have_content "09:00"

    # Send
    click_on "to 1 volunteers"
    expect(page).to have_content Time.now.strftime("%B %d")

    # Delete
    find(".btn-danger").click
    expect(page).not_to have_content "Hello!"
  end
end
