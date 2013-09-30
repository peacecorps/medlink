require 'spec_helper'

describe TwilioController do
  include SmsSpec::Helpers

  let(:number) { '+15555555555' }
  let(:current_user) { FactoryGirl.create(:user, pcv_id: '123456') }

  before(:each) do
    FactoryGirl.create :supply, shortcode: 'ASDF'
    sign_in current_user
  end

  describe "POST 'receive'" do

    it 'routes lists' do
      expect{ post :receive, From: number, Body: 'List supplies'
        }.to raise_error /Not Implemented/
    end

    # -- Friendly messages -----
    {
      unparseable:            'This message should not parse as a valid order',
      confirmation:           '123456, ASDF, 30mg, 50, Somewhere',
      unrecognized_pcvid:     'XXX,    ASDF, 30mg, 50, Somewhere',
      unrecognized_shortcode: '123456, XXX,  30mg, 50, Somewhere'
    }.each do |key, msg|
      it "sends order.#{key} when appropriate" do
        post :receive, From: number, Body: msg
        open_last_text_message_for number
        current_text_message.should have_body I18n.t "order.#{key}"
      end
    end

    # -- unFriendly messages -----

    it "sends sms but forget PCVID" do
      post :receive, From: number, Body: '      , ASDF, 30mg, 50, Somewhere'
      open_last_text_message_for number
      # SE1 (p.7)
      current_text_message.should have_body "PCVID Invalid: Your request was " +
        "not submitted because the PCVID was incorrect. Please resubmit " +
        "your request in this format: PCVID, Supply short name, dose, " +
        "qty, location."
    end

    it "sends sms but forget supply shortcode" do
      post :receive, From: number, Body: '123456,     , 30mg, 50, Somewhere'
      open_last_text_message_for number
      # SE2 (p.7)
      current_text_message.should have_body "Supply short name invalid: " +
        "Your request was not submitted because supply name was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, dose, qty, location."
    end

    # FIXME: to add translation
    # SE3 (p.7)
    it "sends sms but forget dosage" 
    #do
    #  post :receive, From: number, Body: '123456, ASDF, , 50, Somewhere'
    #  open_last_text_message_for number
    #  current_text_message.should have_body "Dose invalid: " +
    #    "Your request was not submitted because dose was incorrect. " +
    #    "Please resubmit the request in this format: PCVID, Supply " +
    #    "short name, dose, qty, location."
    #end

    # FIXME: to add translation
    # SE4 (p.7)
    it "sends sms but forget qty"
    #do
    #  post :receive, From: number, Body: '123456, ASDF, 30mg,   , Somewhere'
    #  open_last_text_message_for number
    #  current_text_message.should have_body "Qty invalid: " +
    #    "Your request was not submitted because quantity was incorrect. " +
    #    "Please resubmit the request in this format: PCVID, Supply " +
    #    "short name, dose, qty, location."
    #end

    # FIXME: Need to add validation
    # SE5 (p.7)
    it "sends sms but forget location"
    # do
    #  post :receive, From: number, Body: '123456, ASDF, 30mg, 50,          '
    #  open_last_text_message_for number
    #  current_text_message.should have_body "Location invalid: " +
    #    "Your request was not submitted because location was incorrect. " +
    #    "Please resubmit the request in this format: PCVID, Supply " +
    #    "short name, dose, qty, location."
    #end

    it 'notifies on duplicate submission' do
      msg = '123456, ASDF, 30mg, 50, Somewhere'
      3.times do
        post :receive, From: number, Body: msg
        open_last_text_message_for number
      end
      current_text_message.should have_body I18n.t "order.duplicate_order"
    end

  end
end
