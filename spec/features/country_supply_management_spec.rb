require "rails_helper"

RSpec.describe "managing country supplies" do
  Given(:pcmo)    { FactoryGirl.create :pcmo }
  Given(:country) { pcmo.country }
  Given(:supply)  { country.available_supplies.random }

  it "lets PCMOs toggle supplies" do
    login_as pcmo
    visit country_supplies_path

    # Disable supply
    row = find("tr", text: supply.name)
    expect(row["class"]).to be_nil
    row.find(".btn-danger").click

    # Re-enable supply
    row = find("tr", text: supply.name)
    expect(row["class"]).to eq "danger"
    row.find(".btn-default").click

    row = find("tr", text: supply.name)
    expect(row["class"]).to be_nil
  end
end
