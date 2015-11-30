require "rails_helper"

RSpec.describe "managing a roster" do
  Given(:admin)   { FactoryGirl.create :admin }
  Given(:country) { admin.country }
  Given!(:a)      { FactoryGirl.create :pcv, email: "a@example.com", country: country }
  Given!(:b)      { FactoryGirl.create :pcv, email: "b@example.com", country: country }
  Given(:body)    { %{
    email,phone,phone2,first_name,last_name,pcv_id,role,location,time_zone
    a@example.com,+1555,,A,User,999,pcv,Place,Fiji
    c@example.com,+1556,+1557,C,,,pcv,Place,Fiji
  } }

  it "can upload and save a roster" do
    login_as admin

    a; b # TODO: why isn't this eager-creating?
    visit country_roster_path
    expect(page).to have_content "a@example.com"
    expect(page).to have_content "b@example.com"

    # TODO: this should be some sort of S3 upload
    roster = RosterUpload.create! uploader: admin, body: body, country: country
    visit edit_country_roster_path(upload_id: roster.id)

    expect(find_all(".has-error").first).to have_content "can't be blank"
    expect(find "tr", text: "Valid Users").to have_content "a@example.com"
    expect(find "tr", text: "Inactive Users").to have_content "b@example.com"

    fill_in "roster[rows_attributes][1][last_name]", with: "Last"
    click_on "Save"
    expect(find_all(".has-error").first).to have_content "can't be blank"

    fill_in "roster[rows_attributes][1][pcv_id]", with: "1000"
    click_on "Save"
    expect(page).not_to have_css ".has-error"

    a = find "tr", text: "a@example.com"
    expect(a).to have_content "999"
    expect(a).to have_content "+1555"

    expect(page).not_to have_content "b@example.com"

    c = find "tr", text: "c@example.com"
    expect(c).to have_content "Last"
    expect(c).to have_content "1000"
    expect(c).to have_content "+1557"

    expect(mail.map &:to).to eq [["c@example.com"]]
  end
end
