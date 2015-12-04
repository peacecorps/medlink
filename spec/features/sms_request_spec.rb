require "rails_helper"

RSpec.describe "Ordering via sms" do
  it "runs end-to-end", :queue_jobs do
    phone     = FactoryGirl.create :phone
    volunteer = phone.user
    country   = volunteer.country
    pcmo      = FactoryGirl.create :pcmo, country: country
    twilio    = country.twilio_account
    supplies  = country.supplies.random 3

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
    expect(request.supplies.sort).to eq supplies.sort

    outgoing = SMS.outgoing.last
    expect(outgoing.number).to eq phone.condensed
    expect(outgoing.text).to match /Thanks! Your request for/
    expect(outgoing.text).to match /\([A-Z]{4,5}\),? and/
    expect(outgoing.text).to match /You can expect a response shortly after/

    # PCMO approves
    login_as pcmo

    visit new_user_response_path(volunteer)
    volunteer.orders.each { |order| choose "orders_#{order.id}_delivery" }
    fill_in "response_extra_text", with: "Ok!"
    expect(queued(ResponseSMSJob).count).to eq 0

    expect { click_on "Send Response" }.to change { queued(ResponseSMSJob).count }.by 1

    # PCV gets notification
    Timecop.travel Time.now + 2.weeks
    ReceiptAckPrompt.new(volunteer.responses.last).send

    message = "Got it!"
    page.driver.post "/medrequest",
      AccountSid: twilio.sid, To: twilio.number, From: phone.number, Body: message

    # PCMO sees response received
    visit responses_path
    expect(page).not_to have_content volunteer.email
    click_on "Archived"
    expect(page).to have_content volunteer.email
  end
end
