require 'spec_helper'

describe TwilioController do
  before :each do
    %w(Sup wit dat).each { |n| create :supply, name: n, shortcode: n }
    @user = create :user, pcv_id: 'asdf'
    create :phone, user: @user
  end

  it "can create multiple orders from an incoming text" do
    body = "Sup wit - Please"

    post :receive, AccountSid: ENV.fetch("TWILIO_ACCOUNT_SID"),
      From: @user.primary_phone.number,
      Body: body

    expect( SMS.incoming.last.text ).to eq body
    expect( @user.orders.map { |o| o.supply.name } ).to eq %w(Sup wit)
    expect( SMS.outgoing.last.text ).to match /request.*received/i
  end

  it "responds with error messages when something is wrong" do
    body = "Bro - do you even liftM?"

    post :receive, AccountSid: ENV.fetch("TWILIO_ACCOUNT_SID"),
      From: @user.primary_phone.number,
      Body: body

    expect( SMS.incoming.last.text ).to eq body
    expect( Order.count ).to be 0
    expect( SMS.outgoing.last.text ).to match /Unrecognized supply/
  end

  it "rejects duplicate messages" do
    2.times do
      post :receive, AccountSid: ENV.fetch("TWILIO_ACCOUNT_SID"),
        From: @user.primary_phone.number,
        Body: "Sup"
    end

    expect( Order.count ).to eq 1
    expect( SMS.outgoing.last.text ).to match /already received/
  end

  it "verifies that messages came from Twilio" do
    expect do
      post :receive,
        From: @user.primary_phone.number,
        Body: "Sup"
    end.to raise_error /account sid/i
  end
end
