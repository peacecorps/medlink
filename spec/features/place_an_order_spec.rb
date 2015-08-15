require 'spec_helper'

describe "A PCV placing an order" do
  before :each do
    @supply = create :supply
    @user   = create :user
    @user.country.supplies << @supply
    login @user
    visit new_request_path
  end

  describe "after being placed" do
    before :each do
      select @supply.name, from: :request_orders_attributes_0_supply_id
      fill_in :request_text, with: "Request instructions"
      click_on "Submit"
    end

    it "created an order for that user" do
      expect( page.text ).to match /success.*order.*has been sent/i
      expect( page ).to have_content @supply.name
    end

    it "can see the order in the PCMO response tracker" do
      logout @user
      pcmo = create :pcmo, country: @user.country
      login pcmo
      visit manage_orders_path
      expect( page.find "#user_pending_table" ).to have_content @supply.name
      expect( Order.last ).not_to be_denied
    end
  end


  it "can display validations" do
    click_on "Submit"
    expect( page.find(".alert").text ).to match /order.*empty/i
  end


  it "lets pcmos place orders for users" do
    logout @user
    pcmo = create :pcmo, country: @user.country
    login pcmo
    visit root_path
    click_on "Requests"
    click_on "Place a Request"

    select @user.name, from: :request_user_id
    select @supply.name, from: :request_orders_attributes_0_supply_id
    click_on "Submit"

    o = Order.last
    expect( o.user_id ).to eq @user.id
    expect( o.request.entered_by ).to eq pcmo.id
    expect( current_path ).to eq manage_orders_path
  end

  it "lets admins place orders for users" do
    logout @user
    admin = create :admin, country: @user.country
    login admin
    visit root_path
    click_on "Requests"
    click_on "Place a Request"

    select @user.name, from: :request_user_id
    select @supply.name, from: :request_orders_attributes_0_supply_id
    click_on "Submit"

    o = Order.last
    expect( o.user_id ).to eq @user.id
    expect( o.request.entered_by ).to eq admin.id
    expect( current_path ).to eq new_admin_user_path
  end
end
