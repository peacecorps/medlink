require "rails_helper"

RSpec.describe "managing master supply list" do
  Given(:admin) { FactoryGirl.create :admin }

  it "can do all the CRUD" do
    login_as admin

    # Create
    visit supplies_path
    click_on "Add New Supply"
    fill_in "Name", with: "Unobtanium"
    fill_in "Shortcode", with: Supply.random.shortcode
    click_on "Save"

    field = find ".has-error", text: "Shortcode"
    expect(field).to have_content "has already been taken"
    fill_in "Shortcode", with: "UNOBT"
    click_on "Save"

    expect(page).to have_content "UNOBT"

    # Update / Delete
    row = find "tr", text: "Unobtanium"
    expect(row["class"]).to be_nil
    row.find(".btn-danger").click

    row = find "tr", text: "Unobtanium"
    expect(row["class"]).to eq "danger"
    row.find(".btn-default").click

    row = find "tr", text: "Unobtanium"
    expect(row["class"]).to be_nil
  end
end
