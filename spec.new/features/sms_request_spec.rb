require "rails_helper"

describe "Ordering via sms" do
  it "runs end-to-end", :vcr do
    phone     = FactoryGirl.create :phone
    volunteer = phone.user
    country   = volunteer.country
    twilio    = country.twilio_account
    supplies  = country.supplies.order("random()").first 3

    # User orders some supplies
    message = "#{supplies.map(&:shortcode).join ", "} - thanks!"
    page.driver.post "/medrequest",
      AccountSid: twilio.sid, To: twilio.number, From: phone.number, Body: message

    incoming = SMS.incoming.last
    expect(incoming.number).to eq phone.number
    expect(incoming.text).to eq message

    request = incoming.request
    expect(request.text).to eq "thanks!"
    expect(request.user).to eq volunteer
    expect(request.supplies).to eq supplies

    outgoing = SMS.outgoing.last
    expect(outgoing.number).to eq phone.condensed
    expect(outgoing.text).to match /Thanks! Your request for #{supplies.first.name}/
    expect(outgoing.text).to match /You can expect a response shortly after/

    skip "PCMO responds to orders"
    skip "user indicates receipt of supplies"
    skip "PCMO sees supplies received"
  end
end
