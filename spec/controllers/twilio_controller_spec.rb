require 'spec_helper'

describe TwilioController do
  let(:number) { '+15555555555' }
  let(:current_user) { FactoryGirl.create(:user, pcv_id: '123456') }

  before(:each) do
    FactoryGirl.create :supply, shortcode: 'ASDF'
    sign_in current_user
  end

  describe "POST 'receive'" do
    include SmsSpec::Helpers

    it 'routes lists' do
      expect{ post :receive, From: number, Body: 'List supplies' }.to raise_error /Not Implemented/
    end

    it 'sends a confirmation message after adding an order' do
      post :receive, From: number, Body: '123456, ASDF, 30mg, 50, Somewhere'
      open_last_text_message_for number
      current_text_message.should have_body I18n.t 'order.confirmation'
    end

    it 'sends an error message on unparseable texts' do
      post :receive, From: number, Body: 'This message should not parse as a valid order'
      open_last_text_message_for number
      current_text_message.should have_body I18n.t 'order.unparseable'    
    end
  end
end