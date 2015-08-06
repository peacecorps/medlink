require 'spec_helper'

describe "Managing Country Supplies" do
  before :each do
    @supply = create :supply
    @country = create :country
    @country.supplies << @supply
  end

  def checkbox_for supply
    id = supply.name.squish.tr " ", "_"
    find :css, "input[type='checkbox']##{id}"
  end

  it "lets admins manage supplies for a country" do
    admin = create :admin
    login admin
    visit country_supplies_path
    within ".admin_country_select" do
      select @country.name
      click_on "Update"
    end

    expect( page ).to have_content @supply.name
    expect( checkbox_for @supply ).to be_checked
    uncheck @supply.name
    expect( checkbox_for @supply ).not_to be_checked
    find('#update-country').click
    expect( checkbox_for @supply ).not_to be_checked
  end

  it "lets PCMO manage supplies for her country only" do
    pcmo = create :pcmo, country: @country
    login pcmo
    visit country_supplies_path

    expect{ find('#pick-country') }.to raise_error(Capybara::ElementNotFound)
    expect( page ).to have_content @supply.name
    expect( checkbox_for @supply ).to be_checked
    uncheck @supply.name
    expect( checkbox_for @supply ).not_to be_checked
    find('#update-country').click
    expect( checkbox_for @supply ).not_to be_checked
  end

  it "does not let a PCV manage supplies for a country" do
    role = create :pcv
    login role

    visit country_supplies_path
    expect( page ).not_to have_content @supply.name

    role.country.supplies << @supply
    visit country_supplies_path
    expect( page ).to have_content @supply.name

    expect{ find('#update-country') }.to raise_error(Capybara::ElementNotFound)
  end
end
