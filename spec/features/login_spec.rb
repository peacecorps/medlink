require 'spec_helper'

describe "Logging in" do
  before :each do
    @user = create :user
  end

  it "does not appear to be logged in initially" do
    visit root_path
    expect( page ).to have_content "Sign In"
  end

  it "can log in with the helper routine" do
    login @user
    visit root_path
    expect( page ).to have_content "Sign Out"
  end

  it "can log in and out manually" do
    visit new_user_session_path
    within ".sign-in" do
      fill_in :user_email, with: @user.email
      fill_in :user_password, with: @user.password
      click_on "Sign In"
    end
    click_on "Sign Out"
    expect( alert.text ).to match /signed out/i
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
      expect( alert.text ).to match /updated/i
    end

    it "can fail to update" do
      fill_in :user_password_confirmation, with: "nw-password"
      click_on "Update"
      expect( page.text ).to match /doesn't match/i
    end
  end

  it "can send password resets" do
    @user.update confirmed_at: 1.week.ago

    visit root_path
    within ".help" do
      fill_in "Email", with: @user.email
      click_on "Send Help Email"
    end

    expect( alert ).to have_content "Email sent to #{@user.email}"

    mail = sent_mail.last
    expect( mail.to ).to eq [@user.email]
    expect( mail.to_s ).to match /Change my password/
  end

  it "can send confirmation emails" do
    @user.update confirmed_at: nil

    visit root_path
    within ".help" do
      fill_in "Email", with: @user.email
      click_on "Send Help Email"
    end

    expect( alert ).to have_content "Email sent to #{@user.email}"

    mail = sent_mail.last
    expect( mail.to ).to eq [@user.email]
    expect( mail.to_s ).to match /Welcome, #{@user.name}/
  end

  it "can fail to find users" do
    visit root_path
    within ".help" do
      fill_in "Email", with: "not_a_user@example.com"
      click_on "Send Help Email"
    end
    expect( alert.text ).to eq "No account found for not_a_user@example.com"
  end
end
