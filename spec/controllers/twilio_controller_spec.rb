require 'spec_helper'

describe TwilioController do
  let(:current_user) { FactoryGirl.create(:user) }
  before { sign_in current_user }

  describe "POST 'receive'" do
    it 'adds orders on parseable texts'
    it 'sends a confirmation message after adding an order'

    it 'sends an error message on unparseable texts' do
      SMS.should_receive(:send_raw).
        with('+15555555555', I18n.t('order.unparseable')).
        and_return(true)

      post 'receive', From: '+15555555555', Body: 'This message should not parse as a valid order'
    end
  end
end