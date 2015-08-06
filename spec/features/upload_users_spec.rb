require 'spec_helper'

describe "Uploading a User CSV", :worker do
  before :each do
    @admin = create :admin
    login @admin
    visit root_path
  end

  def upload_to country, file, overwrite: false
    attach_file "csv", Rails.root.join("spec/data/#{file}.csv")
    select country.name, from: "country_id"
    check "overwrite" if overwrite
    click_button "Upload CSV"
  end

  it "can create users" do
    upload_to @admin.country, "users.good"

    expect( alert.text ).to match /uploaded.*3 users/i
    expect( User.pcv.count ).to eq 3
    expect( sent_mail.flat_map(&:to).sort ).to eq User.pcv.pluck(:email).sort
  end

  it "can handle malformed csvs" do
    upload_to @admin.country, "malformed"

    header = page.find("th.has-error")
    expect( header.text ).to eq "not_a_user_field is not a recognized column"
    expect( User.pcv.count ).to eq 0
    expect( sent_mail.count ).to eq 0
  end

  it "does not create users when there are errors" do
    upload_to @admin.country, "users"

    expect( page.all("td.has-error").count ).to be > 0
    expect( User.pcv.count ).to eq 0
    expect( sent_mail.count ).to eq 0
  end

  it "can be set to overwrite users" do
    create :user, pcv_id: "123"

    upload_to @admin.country, "users.good", overwrite: true

    expect( User.pcv.count ).to eq 3
    expect( sent_mail.count ).to eq 2

    old = User.find_by_pcv_id "123"
    expect( old.email ).to eq "a@example.com"
    expect( old.last_name ).to eq "Person"
  end
end
