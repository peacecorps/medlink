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

    # -- i18n codes -----
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

    # -- English translations -----
    # From Design Doc: SE1(unrecognized_pcvid), SE2(unrecognized_shortcode)
    { unrecognized_pcvid: "PCVID Invalid: Your request was " +
        "not submitted because the PCVID was incorrect. Please resubmit " +
        "your request in this format: PCVID, Supply short name, location.",
      unrecognized_shortcode: "Supply short name invalid: " +
        "Your request was not submitted because supply name was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, location.",
      invalid_location: "Location invalid: " +
        "Your request was not submitted because location was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, location."
    }.each do |key, translation|
      it "translates order.#{key} correctly into English" do
        expect( I18n.t "order.#{key}" ).to eq translation
      end
    end

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
