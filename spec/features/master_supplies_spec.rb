require 'spec_helper'

describe "Master Supply List" do
  before :each do
    @supply = create :supply
  end

  it "lets admins view master supply list" do
    admin = create :admin
    login admin
    visit supplies_path

    expect( page ).to have_content @supply.name
    expect( @supply.orderable ).to be true
  end

  it "prevents pcmo's from viewing master supply list" do
    pcmo = create :pcmo
    login pcmo
    visit supplies_path

    expect( alert.text ).to eq "You are not authorized to view that page"
    expect(current_path).to eq manage_orders_path
  end

  it "prevents pcv's from viewing master supply list" do
    pcv = create :pcv
    login pcv
    visit supplies_path

    expect( alert.text ).to eq "You are not authorized to view that page"
    expect(current_path).to eq new_request_path
  end

end