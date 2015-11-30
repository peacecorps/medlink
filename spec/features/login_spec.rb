require "rails_helper"

RSpec.describe "login emails" do
  it "can request confirmation help" do
    pcv = FactoryGirl.create :pcv, :unconfirmed
    mail.clear

    visit root_path
    within ".help" do
      fill_in "Email", with: pcv.email
    end
    click_on "Send Help Email"

    m = mail.last
    expect(m.to).to eq [pcv.email]

    reset = m.to_s =~ /(\/users\/confirmation[^\s"]+)/ && $1
    expect(reset).to be_present
    visit reset

    expect(page).to have_content "I hereby authorize"
    click_on "Confirm"

    expect(page).to have_validation_error "Password", "can't be blank"

    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_on "Confirm"

    expect(page).to have_content "Request Form"
  end

  it "can request password reset emails" do
    pcv = FactoryGirl.create :pcv
    mail.clear

    visit root_path
    within ".help" do
      fill_in "Email", with: pcv.email
    end
    click_on "Send Help Email"
    m = mail.last

    expect(m.to).to eq [pcv.email]
    expect(m.to_s).not_to match /(\/users\/confirmation[^\s"]+)/

    reset = m.to_s =~ /(\/users\/password[^\s"]+)/ && $1
    expect(reset).to be_present

    visit reset
    expect(page).to have_content "Confirm New Password"
  end

  it "can fail to find emails" do
    visit root_path
    within ".help" do
      fill_in "Email", with: "not_a_real_email@example.com"
    end
    click_on "Send Help Email"
    expect(mail).to be_empty
    expect(flash).to have_content "No account found"
  end
end
