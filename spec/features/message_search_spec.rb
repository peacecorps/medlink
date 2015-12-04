require "rails_helper"

RSpec.describe "searching for messages" do
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

  it "uses the sort table" do
    5.times { |n| FactoryGirl.create :sms, direction: :incoming, created_at: n.weeks.ago }

    login_as admin
    visit messages_path per_page: 2

    rows = page.find_all "#messages tbody tr"
    p1 = rows.first.text
    expect(rows.count).to eq 2

    click_on "Next"
    expect(page.find_all("#messages tbody tr").count).to eq 2

    click_on "Next"
    expect(page.find_all("#messages tbody tr").count).to eq 1

    click_on "Date"
    expect(page.find("#messages tbody tr").text).to eq p1
  end
end
