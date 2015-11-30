require "rails_helper"

RSpec.describe "managing users" do
  Given(:admin) { FactoryGirl.create :admin }

  it "lets admins do all the CRUD" do
    login_as admin
    within ".users" do
      select "Togo", from: "country_id"
      click_on "Manage Users"
    end

    click_on "New User"
    fill_in "First name", with: "First"
    fill_in "Last name", with: "Last"
    fill_in "Address / location", with: "Place"
    fill_in "PCV ID", with: "923745928"
    select "PCV", from: "Role"
    fill_in "Phone numbers", with: "+15551, +15552"
    click_on "Create User"

    expect(page).to have_validation_error "Email", "can't be blank"
    fill_in "Email", with: "new_user@example.com"
    click_on "Create User"

    row = find "tr", text: "new_user@example.com"
    expect(row).to have_content "+15552"
    row.click_on "Edit"

    expect(page).not_to have_content "Email"
    fill_in "Last name", with: ""
    click_on "Update User"

    expect(page).to have_validation_error "Last name", "can't be blank"
    fill_in "Last name", with: "Updated"
    click_on "Update User"

    row = find "tr", text: "new_user@example.com"
    expect(row).to have_content "Updated"

    row.click_on "Edit"
    select "First Updated", from: "_user_id"
    click_on "Select"

    expect(page).to have_content "Edit Account"

    click_on "Inactivate User"
    expect(page.current_path).to eq country_roster_path
    expect(page).not_to have_content "new_user@example.com"
  end
end
