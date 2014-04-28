require 'spec_helper'

describe "responding to orders" do
  before :each do
    @country = create :country
    @user = create :user, country: @country
    create :phone, user: @user
    4.times { create :order, user: @user, country: @country }

    @pcmo = create :pcmo, country: @country
    login @pcmo
  end

  it "allows admins to select what country to manage" do
    admin = create :admin
    login admin
    visit manage_orders_path

    expect( page ).not_to have_content "Pending Requests"

    within ".admin_country_select" do
      select @user.country.name, from: :country_country_id
      click_button "Select Country"
    end

    expect( alert.text ).to match /#{@user.country.name}/
    expect( page ).to have_content "Pending Requests"
    expect( page.text ).to include @user.name
  end

  it "can bulk process orders", :worker do
    ActionMailer::Base.deliveries.clear

    visit new_user_response_path(@user)
    # TODO: these specifications are brittle ...
    choose :orders_4_delivery_method_delivery
    choose :orders_3_delivery_method_denial
    fill_in :response_extra_text, with: "Extra instructions ..."
    click_on "Send Response"

    expect( alert.text ).to match /response.*sent.*#{@user.name}/i

    sms = SMS.outgoing.last
    expect( sms.number ).to eq @user.primary_phone.number

    mail = ActionMailer::Base.deliveries.last
    expect( mail.to ).to eq [@user.email]
  end

  it "can archive responses" do
    response = create :response, user: @user
    @user.orders.each do |o|
      o.update_attributes response: response, delivery_method: DeliveryMethod.to_a.sample
    end

    visit responses_path
    expect( page ).to have_content @user.first_name
    click_on "archive-#{response.id}" # TODO: less brittle selector

    expect( alert.text ).to match /response.*archived/i
    expect( page ).not_to have_content @user.first_name

    %w(All Archived).each do |selected|
      click_on selected
      expect( page ).to have_content @user.first_name
    end

    click_on "unarchive-#{response.id}"
    expect( alert.text ).to match /response.*unarchived/i
  end
end
