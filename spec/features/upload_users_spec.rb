require 'spec_helper'

describe "Uploading a User CSV", :worker do
  before :each do
    @admin = create :admin
    login @admin
    visit root_path
  end

  it "redisplays if no country is selected" do
    attach_file "csv", Rails.root.join("spec/data/users.good.csv")
    click_button "Upload CSV"

    expect( page.find(".alert").text ).to match /country/i
    expect( User.pcv.count ).to eq 0
  end

  it "can create users" do
    attach_file "csv", Rails.root.join("spec/data/users.good.csv")
    select @admin.country.name, from: "country_id"
    click_button "Upload CSV"

    expect( alert.text ).to match /uploaded.*3 users/i
    expect( User.pcv.count ).to eq 3
    expect( sent_mail.flat_map(&:to).sort ).to eq User.pcv.pluck(:email).sort
  end

  describe "uploads with some errors" do
    before :each do
      attach_file "csv", Rails.root.join("spec/data/users.csv")
      select @admin.country.name, from: "country_id"
      click_button "Upload CSV"
    end

    it "redisplays lines with errors" do
      alert = page.find(".alert").text
      expect( alert ).to match /d@example.com/
      expect( alert ).to match /role.*blank/i

      expect( User.pcv.count ).to eq 3
    end

    it "still sends welcome emails to valid users" do
      expect( sent_mail.count ).to eq 3
      expect( sent_mail.flat_map &:to ).not_to include "d@example.com"
    end
  end
end
