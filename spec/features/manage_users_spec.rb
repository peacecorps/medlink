require 'spec_helper'

describe "User management" do
  before :each do
    @admin = create :admin
    login @admin
    visit root_path
  end

  it "redirects non-admin users" do
    logout
    login create :pcmo
    visit new_admin_user_path

    expect( alert.text ).to match /must be an admin/i
    expect( current_path ).to eq manage_orders_path
  end

  describe "create" do
    it "can create", :worker do
      within "#new_user" do
        fill_in :user_pcv_id, with: "112358"
        fill_in :user_first_name, with: "James"
        fill_in :user_last_name, with: "Dabbs"
        fill_in :user_email, with: "james@example.com"
        select Country.last.name, from: :user_country_id
        fill_in :user_location, with: "Hotlanta"
        select "PCV", from: :user_role
        select "Eastern Time (US & Canada)", from: :user_time_zone
        click_on "Add"
      end

      expect( alert.text ).to match /added.*user/i
      expect( User.last.name ).to eq "James Dabbs"
    end

    it "redisplays errors" do
      click_on "Add"
      expect( page.find(".alert").text ).to match /email can't be blank/i
      expect( User.pcv.count ).to be_zero
    end
  end

  describe "edit" do
    before :each do
      @user = create :user
      visit root_path
      within ".admin_country_select" do
        select @user.country.name
        click_on "Update"
      end
      select @user.name, from: :edit_user
      click_on "Edit User"
    end

    it "can edit users" do
      fill_in :user_first_name, with: "Editward"
      click_on "Save"

      expect( page.find(".alert").text ).to match /success.*changes/i
      expect( User.last.first_name ).to eq "Editward"
    end

    it "can save with no changes" do
      click_on "Save"
      expect( page.find(".alert").text ).to match /no changes/i
    end

    it "fails to update with invalid data" do
      fill_in :user_first_name, with: ""
      click_on "Save"

      expect( page ).to have_content "First name can't be blank"
      expect( User.last.first_name ).to eq @user.first_name
    end
  end
end
