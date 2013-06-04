require 'spec_helper'

describe TwilioController do
  let(:number) { '+15555555555' }
  let(:current_user) { FactoryGirl.create(:user, pcv_id: '123456') }

  before(:each) do
    FactoryGirl.create :supply, shortcode: 'ASDF'
    sign_in current_user
  end

  describe "POST 'receive'" do
    it 'routes lists' do
      expect{ post :receive, From: number, Body: 'List supplies' }.to raise_error /Not Implemented/
    end

    it 'sends a confirmation message after adding an order' do
      SMS.should_receive(:send_raw).and_return(true)
      post :receive, From: number, Body: '123456, ASDF, 30mg, 50, Somewhere'
    end

    it 'sends an error message on unparseable texts' do
      SMS.should_receive(:send_raw).
        with(number, I18n.t('order.unparseable')).
        and_return(true)

      post :receive, From: number, Body: 'This message should not parse as a valid order'
    end
  end
end