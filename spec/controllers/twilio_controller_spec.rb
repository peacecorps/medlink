require 'spec_helper'

describe TwilioController do
  def request user, body
    post :receive, AccountSid: @twilio.sid,
      To:   @twilio.number,
      From: user.primary_phone.number,
      Body: body
  end

  before :each do
    @twilio = TwilioAccount.default
    @twilio.save!

    @user = create :user, pcv_id: 'asdf'
    create :phone, user: @user
    %w(Sup wit dat).each do |n|
      @supply = create :supply, name: n, shortcode: n
      @user.country.supplies << @supply
    end
  end

  it "can create multiple orders from an incoming text" do
    body = "Sup wit - Please"
    request @user, body

    expect( SMS.incoming.last.text ).to eq body
    expect( @user.orders.map { |o| o.supply.name }.sort ).to eq %w(Sup wit)
    expect( SMS.outgoing.last.text ).to match /request.*received/i
  end

  it "responds with error messages when something is wrong" do
    body = "Bro - do you even liftM?"
    request @user, body

    expect( SMS.incoming.last.text ).to eq body
    expect( Order.count ).to be 0
    expect( SMS.outgoing.last.text ).to match /Unrecognized supply/
  end

  it "rejects duplicate messages" do
    2.times { request @user, "Sup" }

    expect( Order.count ).to eq 1
    expect( SMS.outgoing.last.text ).to match /already received/
  end

  it "verifies that messages came from Twilio" do
    post :receive,
      From: @user.primary_phone.number,
      Body: "Sup"
    expect( response.status ).to eq 400
  end
end
