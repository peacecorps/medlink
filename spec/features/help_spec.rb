require "rails_helper"

RSpec.describe "help page" do
  Given(:country) { Country.random }
  Given(:pcv)     { create :pcv, country: country }
  Given(:pcmo)    { create :pcmo, country: country }

  before :each do
    @s1 = Supply.random
    @s1.update! orderable: false

    @s2 = country.available_supplies.random
    country.supplies.delete @s2

    @s3 = country.available_supplies.random
  end

  it "logged out" do
    visit help_path
    expect(page).to     have_content "Ordering Supplies"
    expect(page).not_to have_content "Processing Volunteer Orders"
    expect(page).not_to have_content @s1.shortcode
    expect(page).not_to have_content @s2.shortcode
    expect(page).not_to have_content @s3.shortcode
  end

  it "as pcv" do
    login_as pcv
    visit help_path
    expect(page).to     have_content "Ordering Supplies"
    expect(page).not_to have_content "Processing Volunteer Orders"
    expect(page).not_to have_content @s1.shortcode
    expect(page).not_to have_content @s2.shortcode
    expect(page).to     have_content @s3.shortcode
  end

  it "as pcmo" do
    login_as pcmo
    visit help_path
    expect(page).not_to have_content "Ordering Supplies"
    expect(page).to     have_content "Processing Volunteer Orders"
    expect(page).not_to have_content @s1.shortcode
    expect(page).not_to have_content @s2.shortcode
    expect(page).to     have_content @s3.shortcode
  end
end
