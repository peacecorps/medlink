require 'spec_helper'

describe "Edit profile" do
  it "allows users to edit their own profile" do
    pcv = create :pcv
    login pcv

    visit root_path
    click_on "Edit Account"

    within ".edit_user" do
      fill_in "First name", with: ""
      click_on "Save"
    end

    expect( page ).to have_content "can't be blank"

    within ".edit_user" do
      fill_in "First name", with: "Jim"
      click_on "Save"
    end

    pcv.reload
    expect( pcv.first_name ).to eq "Jim"
    expect( page ).to have_content pcv.name
  end
end
