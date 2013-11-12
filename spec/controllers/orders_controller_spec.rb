require 'spec_helper'

describe OrdersController do
  let(:current_user) { FactoryGirl.create(:user) }
  before(:each) { sign_in current_user }

  it { renders_successfully :index }
  it { renders_successfully :new   }

  describe '#manage' do
    it 'redirects basic users' do
      get :manage
      expect( response ).to be_redirection
    end

    it 'allows pcmos' do
      current_user.update_attributes role: "pcmo"
      get :manage
      expect( response ).to be_success
    end
  end

  describe "POST 'create'" do
    it "redirects on creation" do
      supply = FactoryGirl.create :supply
      post 'create', order: {
        user_id: current_user.id, supply_id: supply.id,
        location: 'Roswell', unit: '20', quantity: 20 }
      expect( response ).to be_redirection
    end

    it "renders on failure" do
      post 'create', order: {user_id: current_user.id, supply_id: 'QWERTY'}
      expect( response ).to be_success
    end
  end
end

