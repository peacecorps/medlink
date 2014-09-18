require 'spec_helper'

describe "Managing Country Supplies" do
  before :each do
    @supply = create :supply
    @country = create :country
    @country.supplies << @supply
  end

  it "lets admins manage supplies for a country" do
    admin = create :admin
    login admin
    visit country_supplies_path
    select @country.name, from: "country[country_id]"
    find('#pick-country').click 
    expect( page ).to have_content @supply.name
    cbox = find(:css, "input[type='checkbox']#" + @supply.name.squish.tr(" ","_"))
    expect( cbox ).to be_checked 
    uncheck @supply.name 
    expect( cbox ).not_to be_checked 
    find('#update-country').click 
    expect( cbox ).not_to be_checked 
  end

  it "does not let a PCMO/PCV manage supplies for a country" do
    ["pcmo","pcv"].each do |role|
      role = create role.to_sym 
      login role
      visit country_supplies_path
      expect( page ).to have_content @supply.name
      #save_and_open_page
      expect{ find('#update-country') }.to raise_error(Capybara::ElementNotFound)
    end
  end


end

