require "rails_helper"

describe "searching for messages" do
  Given(:admin) { FactoryGirl.create :admin }

  it "lets admins search" do
    sms = FactoryGirl.create :sms, direction: :incoming, text: "blerg"

    login_as admin
    visit messages_path
    expect(page).to have_content "blerg"

    # Search for incoming invalid
    select "Invalid", from: "Validity"
    click_on "Search"
    expect(page).to have_content "blerg"

    # Search for different country
    other = Country.where.not(id: sms.user.country.id).random
    select other.name, from: "Country"
    click_on "Search"
    expect(page).not_to have_content "blerg"
  end
end
