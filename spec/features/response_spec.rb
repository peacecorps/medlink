require 'spec_helper'

describe "responding to orders" do
  before :each do
    @country = create :country
    @user = create :user, country: @country
    create :phone, user: @user
    4.times { create :order, user: @user, country: @country }
    # FIXME: having to remember this seems too brittle
    @user.update_attributes waiting_since: @user.orders.without_responses.minimum(:created_at)

    @pcmo = create :pcmo, country: @country
    login @pcmo
  end

  it "allows admins to select what country to manage" do
    admin = create :admin
    login admin
    visit manage_orders_path

    expect( page.text ).not_to include @user.name

    within ".admin_country_select" do
      select @user.country.name, from: :country_country_id
      click_button "Update"
    end

    expect( alert.text ).to match /#{@user.country.name}/
    expect( page ).to have_content "Pending Requests"
    expect( page.text ).to include @user.name
  end

  it "can bulk process orders", :worker do
    ActionMailer::Base.deliveries.clear

    visit new_user_response_path(@user)
    # TODO: these specifications are brittle ...
    o1,o2 = @user.orders.first 2
    choose "orders_#{o1.id}_delivery_method_delivery"
    choose "orders_#{o2.id}_delivery_method_denial"
    fill_in :response_extra_text, with: "Extra instructions ..."
    click_on "Send Response"

    expect( alert.text ).to match /response.*sent.*#{@user.name}/i

    sms = SMS.outgoing.last
    expect( sms.number ).to eq @user.primary_phone.number

    mail = ActionMailer::Base.deliveries.last
    expect( mail.to ).to eq [@user.email]
  end

  it "does not create a response when nothing is selected" do
    visit new_user_response_path(@user)
    click_on "Send Response"

    expect( alert.text ).to match /no response/i
    expect( Response.count ).to eq 0
  end

  it "auto-archives orders when possible", :worker do
    visit new_user_response_path(@user)
    @user.orders.zip(%w( denial purchase denial purchase )).each do |order, method|
      choose "orders_#{order.id}_delivery_method_#{method}"
    end
    click_on "Send Response"

    visit responses_path
    expect( page ).not_to have_content @user.first_name
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
