require 'spec_helper'

describe OrdersController do
  let (:current_user) { FactoryGirl.create(:user) }
  before {
    sign_in current_user
  }

  describe "GET 'new'" do
    it 'displays a template' do
      get 'new'
      expect( response ).to be_success
    end
  end

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
        supply_id: Supply.last.id, unit: '5', quantity: 5, location: 'Sandy Springs' }
      post 'create', order: order

      order = Order.last
      #FIXME: expect( order.responded_at ).to be_nil
      #FIXME: expect( response ).to be_redirection
    end
  end

  context 'with an existing order' do
    before(:each) { @order = FactoryGirl.create :order,
      user_id: current_user.id, location: 'Decatur' }

    describe "GET 'edit'" do
      it 'displays a template' do
        get 'edit', id: @order.id
        expect( response ).to be_success
      end
    end

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

  describe "GET 'index'" do
    before do
      FactoryGirl.create(:order, user_id: current_user.id, location: 'Cumming')
    end
    it "returns success with valid data" do
      get 'index'
      expect( response ).to be_success
    end
  end

end
