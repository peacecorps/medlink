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

    # Upload comes in from a client-side S3 upload
    response = page.driver.post "/country/roster/upload", file: "https://example.com/roster.csv"
    expect(response.status).to eq 200
    json = JSON.parse response.body
    expect(json["status"]).to eq "ok"

    upload = RosterUpload.find json["upload_id"]

    # Poll while we fetch from S3
    visit edit_country_roster_path(upload_id: upload.id)
    response = page.driver.get "/country/roster/edit", upload_id: upload.id
    expect(page).to have_content "Fetching"

    visit poll_country_roster_path(upload_id: upload.id)
    json = JSON.parse page.body
    expect(json["ready"]).to eq false

    upload.update! body: body
    visit poll_country_roster_path(upload_id: upload.id)
    json = JSON.parse page.body
    expect(json["ready"]).to eq true

    # See the fetched content
    visit edit_country_roster_path(upload_id: upload.id)
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
