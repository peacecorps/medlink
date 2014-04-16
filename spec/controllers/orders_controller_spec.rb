require 'spec_helper'

# TODO: port, fix, or remove :broken tagged specs
describe OrdersController, :broken do
  let(:current_user) { FactoryGirl.create(:user) }
  before(:each) { login current_user }

  it "can show a user their orders" do
    visit orders_path
    binding.pry
  end

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
        location: 'Roswell' }
      expect( response ).to be_redirection
    end

    it "renders on failure" do
      post 'create', order: {user_id: current_user.id, supply_id: 'QWERTY'}
      expect( response ).to be_success
    end

    it "rejects orders without a user" do
      post 'create', order: { supply_id: 'QWERTY' }
      expect( response ).to render_template :new
    end
  end
end

