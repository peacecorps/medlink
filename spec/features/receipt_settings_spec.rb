require "rails_helper"

RSpec.describe "receipt recorder language processing" do
  after(:all) { SMS::ReceiptRecorder::Classifier.reset! }

  it "allows admins to change accepted responses" do
    c = SMS::ReceiptRecorder::Classifier.new
    expect(c.affirmative? "yup").to eq true
    expect(c.affirmative? "affirmative").to eq false

    login_as create :admin
    visit edit_receipts_path
    fill_in "receipts[affirmations]", with: "yarp\naffirmative"
    click_on "Save"

    expect(page).to have_content "yarp"

    c = SMS::ReceiptRecorder::Classifier.new
    expect(c.affirmative? "yup").to eq false
    expect(c.affirmative? "affirmative").to eq true
  end
end
