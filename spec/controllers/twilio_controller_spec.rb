require 'spec_helper'

describe TwilioController, :broken do
  include SmsSpec::Helpers

  before :each do
    %w(Sup wit dat).each { |n| FactoryGirl.create :supply, name: n, shortcode: n }
    @user = FactoryGirl.create :user, pcv_id: 'asdf'
    FactoryGirl.create :phone_number, user: @user
  end

  it "can create multiple orders from an incoming text" do
    body = "Sup wit - Please"

    post :receive,
      From: @user.primary_phone.display,
      Body: body

    expect( SMS.incoming.last.text ).to eq body
    expect( @user.orders.map { |o| o.supply.name } ).to eq %w(Sup wit)
    expect( SMS.outgoing.last.text ).to match /Request received/
  end

  it "responds with error messages when something is wrong" do
    body = "Bro - do you even liftM?"

    post :receive,
      From: @user.primary_phone.display,
      Body: body

    expect( SMS.incoming.last.text ).to eq body
    expect( Order.count ).to be 0
    expect( SMS.outgoing.last.text ).to match /Unrecognized supply/
  end
end
