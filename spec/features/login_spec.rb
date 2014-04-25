require 'spec_helper'

describe "Logging in" do
  before :each do
    @user = create :user
  end

  it "does not appear to be logged in initially" do
    visit root_path
    expect( page ).to have_content "Sign in"
  end

  it "can log in with the helper routine" do
    login @user
    visit root_path
    expect( page ).to have_content "Sign Out"
  end

  describe "changing password" do
    before :each do
      login @user
      visit edit_user_registration_path
      fill_in :user_current_password, with: @user.password
      fill_in :user_password, with: "new-password"
    end

    it "can successfully update" do
      fill_in :user_password_confirmation, with: "new-password"
      click_on "Update"
      expect( page.find(".flash").text ).to match /updated/i
    end

    it "can fail to update" do
      fill_in :user_password_confirmation, with: "nw-password"
      click_on "Update"
      expect( page.text ).to match /doesn't match/i
    end
  end
end
