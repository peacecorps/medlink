require 'spec_helper'

describe "A PCV placing an order" do
  before :each do
    @supply = create :supply
    @user = create :user
    login @user
    visit new_order_path
    select @supply.name, from: :order_supply_id
    fill_in :order_request_text, with: "Request instructions"
    click_on "Submit"
  end

  it "created an order for that user" do
    expect( page.text ).to match /success.*order.*has been sent/i
    expect( page.find "#request-history" ).to have_content @supply.name
  end

  it "can see the order in the PCMO response tracker" do
    logout
    pcmo = create :pcmo, country: @user.country
    login pcmo
    visit manage_orders_path
    expect( page.find "#pending-requests" ).to have_content @supply.name
  end
end
