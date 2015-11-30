require "rails_helper"

RSpec.describe "downloading reports" do
  Given(:admin)     { FactoryGirl.create :admin }
  Given(:pcmo)      { FactoryGirl.create :pcmo }
  Given(:elsewhere) { Country.where.not(id: [admin.country_id, pcmo.country_id]).first! }

  it "allows admins to download reports" do
    FactoryGirl.create :response, order_count: 2

    login_as admin
    visit reports_path

    expect(page).to have_content "Users"
    expect(page).to have_content "PCMO response times"
    click_on "Order History"

    csv = CSV.parse page.body, headers: true
    expect(csv.count).to eq Order.count
  end

  it "allows PCMOs to download (some) reports" do
    FactoryGirl.create :order, country: pcmo.country
    FactoryGirl.create :order, country: elsewhere

    login_as pcmo
    visit reports_path

    expect(page).not_to have_content "Users"
    expect(page).not_to have_content "PCMO response times"
    click_on "Order History"

    csv = CSV.parse page.body, headers: true
    expect(csv.count).to eq pcmo.country.orders.count
  end
end
