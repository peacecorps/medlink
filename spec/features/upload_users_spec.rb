require 'spec_helper'

describe "Uploading a User CSV" do
  before :each do
    @admin = create :admin
    login @admin
    visit root_path
  end

  it "redisplays if no country is selected" do
    attach_file "csv", Rails.root.join("spec/data/users.good.csv")
    click_button "Upload CSV"

    expect( page.find(".flash").text ).to match /country/i
    expect( User.pcv.count ).to eq 0
  end

  it "can create users" do
    attach_file "csv", Rails.root.join("spec/data/users.good.csv")
    select @admin.country.name, from: "country_id"
    click_button "Upload CSV"

    expect( page.find(".flash").text ).to match /uploaded.*3 users/i
    expect( User.pcv.count ).to eq 3
  end

  it "downloads lines with errors" do
    attach_file "csv", Rails.root.join("spec/data/users.csv")
    select @admin.country.name, from: "country_id"
    click_button "Upload CSV"

    row = CSV.parse(page.html).first
    expect( row.first ).to eq "d@example.com"
    expect( row.last  ).to match /role.*blank/i

    expect( User.pcv.count ).to eq 3
  end
end
