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
    it "redirects on creation" do
      post 'create', order: {user_id: current_user.id}
      expect( response ).to be_redirection
    end
    it "renders on failure" do
      FactoryGirl.create(:supply, shortcode: 'CODE')
      order = {user_id: current_user}
      order[:requests_attributes] = {supply_id: 'QWERTY'}
      post 'create', order: order
      expect( response ).to be_success
    end
  end

  describe "POST 'create' nested requests" do
    before(:each) { FactoryGirl.create(:supply, shortcode: 'CODE') }
    it "returns http success" do
      order = {user_id: current_user.id}
      order[:requests_attributes] = {
        supply_id: 'CODE', dose: '5', quantity: 5 }
      post 'create', order: order
      expect( response ).to be_redirection
    end
  end

  context 'with an existing order' do
    before(:each) { @order = FactoryGirl.create :order, user_id: current_user.id }

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
        expect( response ).to be_redirection
      end
    end
  end

  describe "GET 'index'" do
    before do
      FactoryGirl.create(:order, user_id: current_user.id,
                         requests: FactoryGirl.create_list(:request, 10))
    end
    it "returns success with valid data" do
      get 'index'
      expect( response ).to be_success
    end
  end

end
