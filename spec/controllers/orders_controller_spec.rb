require 'spec_helper'

describe OrdersController do
  let(:current_user) { FactoryGirl.create(:user) }
  before(:each) { sign_in current_user }

  it { renders_successfully :index }
  it { renders_successfully :new   }

  context 'with an existing order' do
    before(:each) do
      @order = FactoryGirl.create :order, user: current_user
    end

    it { renders_successfully :edit, id: @order.id }
  end

  describe '#manage' do
    it 'redirects basic users' do
      get :manage
      expect( response ).to be_redirection
    end

    it 'allows pcmos' do
      current_user.update_attributes role: :pcmo
      get :manage
      expect( response ).to be_success
    end
  end

  # TODO: the remaining specs could stand to be cleaned up:
  describe "POST 'create'" do
    before(:each) { FactoryGirl.create(:supply, shortcode: 'CODE') }
    it "redirects on creation" do
      post 'create', order: {
        user_id: current_user.id, supply_id: Supply.last.id,
        location: 'Roswell', unit: '20', quantity: 20 }
      expect( response ).to be_redirection
    end
    it "renders on failure" do
      FactoryGirl.create(:supply, shortcode: 'CODE')
      order = {user_id: current_user, supply_id: 'QWERTY'}
      post 'create', order: order
      expect( response ).to be_success
    end
  end

  describe "POST 'create' nested requests" do
    before(:each) { FactoryGirl.create(:supply, shortcode: 'CODE') }
    it "returns http success" do
      order = { user_id: current_user.id,
        supply_id: Supply.last.id, unit: '5', quantity: 5,
        location: 'Sandy Springs' }
      post 'create', order: order

      order = Order.last
    end
  end

  context 'with an existing order' do
    describe "PUT 'update'", :worker do
      it "redirects on success" do
        put :update, id: @order.id, order: {
          phone: '678-315-5999', email: 'test@example.com'}

        order = Order.last
        expect( order.responded_at ).not_to be_nil
        expect( response ).to be_redirection
      end
    end
  end

end
