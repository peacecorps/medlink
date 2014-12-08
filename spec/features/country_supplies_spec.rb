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

    select @country.name, from: "country[country_id]"
    find('#pick-country').click
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

    expect( page ).to have_content @supply.name
    expect{ find('#update-country') }.to raise_error(Capybara::ElementNotFound)
  end
end
