require 'spec_helper'

describe "Message search" do
  before :each do
    @pcmo = create :pcmo

    @supply = create :supply
    @pcmo.country.supplies << @supply

    u1, u2 = 2.times.map { create :user, country: @pcmo.country }
    u3 = create :user
    @other_country = u3.country

    send_text u1, "help"
    send_text u2, @supply.shortcode
    send_text u3, "wat"
  end

  it "allows pcmos to see messages in their country" do
    login @pcmo
    visit messages_path

    expect( all("#messages tbody tr").count ).to eq 2
    expect( page ).to have_content "help"
    expect( page ).not_to have_content "wat"

    select "Both", from: "Direction"
    click_on "Search"
    expect( all("#messages tbody tr").count ).to eq 4
  end

  it "allows admins to search across countries" do
    admin = create :admin
    login admin
    visit messages_path

    expect( all("#messages tbody tr").count ).to eq 3
    expect( page ).to have_content @supply.shortcode

    select "Invalid", from: "Validity"
    click_on "Search"
    expect( all("#messages tbody tr").count ).to eq 2
    expect( page ).not_to have_content @supply.shortcode

    select "Valid", from: "Validity"
    select @other_country.name, from: "Country"
    click_on "Search"
    expect( all("#messages tbody tr").count ).to eq 0

    select "Outgoing", from: "Direction"
    click_on "Search"
    expect( all("#messages tbody tr").count ).to eq 1
  end
end
