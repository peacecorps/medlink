require 'spec_helper'

describe "Logging in" do
  let(:current_user) { create :user }

  it "does not appear to be logged in initially" do
    visit root_path
    expect( page ).to have_content "Sign in"
  end

  it "can log in with the helper routine" do
    login current_user
    visit root_path
    expect( page ).to have_content "Sign Out"
  end
end
