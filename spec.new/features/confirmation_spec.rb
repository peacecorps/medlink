require "rails_helper"

describe "confirmation emails" do
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
end
