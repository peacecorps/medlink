require "rails_helper"

RSpec.describe "managing users" do
  Given(:admin) { FactoryGirl.create :admin }

  it "lets admins do all the CRUD" do
    login_as admin
    within ".users" do
      select "Togo", from: "country_id"
      click_on "Manage Users"
    end

    # FIXME: this is an artifact of the awkward way we're nesting
    #   non-React contents inside the React Roster component, causing
    #   it to be double-rendered on the page.
    #   Once the upload is consistent, we should replace this with the
    #   more natural `click_on "New User"`
    button = find_all("a", text: "New User").first
    button.click
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

    user = User.find_by_email "new_user@example.com"
    visit edit_admin_user_path(user)

    expect(page).not_to have_content "can't be blank"
    fill_in "Last name", with: ""
    click_on "Update User"

    expect(page).to have_validation_error "Last name", "can't be blank"
    fill_in "Last name", with: "Updated"
    fill_in "Phone numbers", with: "+15551, +15553"
    click_on "Update User"

    expect(flash).to have_content "last_name=Updated"
    expect(flash).to have_content "phone_numbers=+15551, +15553"
    expect(flash).not_to have_content "country"

    visit edit_admin_user_path(user)
    within ".edit_user" do
      select "Tonga", from: "Country"
    end
    click_on "Update User"

    expect(flash).to have_content "country=Tonga"
    expect(flash).not_to have_content "phone_numbers="

    user.reload
    expect(user.last_name).to eq "Updated"
    expect(user.country.name).to eq "Tonga"

    visit edit_admin_user_path(user)
    within ".edit_user" do
      select "Togo", from: "Country"
    end
    click_on "Update User"

    visit edit_admin_user_path(user)
    select "First Updated", from: "user_id"
    click_on "Select"

    expect(page).to have_content "Edit Account"

    click_on "Inactivate User"
    expect(page.current_path).to eq country_roster_path
    expect(page).not_to have_content "new_user@example.com"
  end
end
