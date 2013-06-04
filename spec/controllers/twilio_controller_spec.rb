require 'spec_helper'

describe TwilioController do
  let(:current_user) { FactoryGirl.create(:user, pcv_id: '123456') }

  before(:each) do
    FactoryGirl.create :supply, shortcode: 'ASDF'
    sign_in current_user
  end

  describe "POST 'receive'" do
    it 'adds orders on parseable texts'

    it 'sends a confirmation message after adding an order' do
      SMS.should_receive(:send_raw).and_return(true)
      post 'receive', From: '+15555555555', Body: '123456, ASDF, 30mg, 50, Somewhere'
    end

    it 'sends an error message on unparseable texts' do
      SMS.should_receive(:send_raw).
        with('+15555555555', I18n.t('order.unparseable')).
        and_return(true)

      post 'receive', From: '+15555555555', Body: 'This message should not parse as a valid order'
    end
  end
end