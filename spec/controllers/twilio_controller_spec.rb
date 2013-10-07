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
    # Note that we have some translations for events that can't ever happen
    #   (like dose being invalid). Such is the nature of spec-driven development.
    #
    # TODO: are these deliberately inconsistent in phrasing "the/your request"?
    # ANSWER: Check Design document for phrasing.
    { unrecognized_pcvid: "PCVID Invalid: Your request was " +
        "not submitted because the PCVID was incorrect. Please resubmit " +
        "your request in this format: PCVID, Supply short name, dose, " +
        "qty, location.",
      unrecognized_shortcode: "Supply short name invalid: " +
        "Your request was not submitted because supply name was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, dose, qty, location.",
      invalid_dose: "Dose invalid: " + 
        "Your request was not submitted because dose was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, dose, qty, location.",
      invalid_quantity: "Qty invalid: " +
        "Your request was not submitted because quantity was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, dose, qty, location.",
      invalid_location: "Location invalid: " +
        "Your request was not submitted because location was incorrect. " +
        "Please resubmit the request in this format: PCVID, Supply " +
        "short name, dose, qty, location."
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
