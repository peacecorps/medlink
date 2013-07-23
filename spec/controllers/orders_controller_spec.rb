require 'spec_helper'

describe OrdersController do
  let (:current_user) { FactoryGirl.create(:user) }
  before {
    sign_in current_user
  }

  describe "POST 'create'" do
    it "returns http success" do
      post 'create', order: {user_id: current_user.id}
      response.should be_redirection
    end
    it "returns http failure (bad order create params)"
  end

  describe "POST 'create' nested requests" do
    before(:each) { FactoryGirl.create(:supply, shortcode: 'CODE') }
    it "returns http success" do
      order = {user_id: current_user.id}
      order[:requests_attributes] = {
        supply_id: 'CODE', dose: '5', quantity: 5 }
      post 'create', order: order
      response.should be_redirection
    end
  end

  describe "PUT 'update'", :worker do
    let :order do
      FactoryGirl.create(:order, user_id: current_user.id)
    end
    it "returns http success" do
      put :update, id: order.id, order: {
        phone: '678-315-5999', email: 'test@example.com'}
      response.should be_redirection
    end
    it "returns http failure (bad order update params)"
  end

  describe "GET 'show'" do
    it "add show order spec"
  end

  describe "GET 'index'" do
    before do
      FactoryGirl.create(:order, user_id: current_user.id,
                         requests: FactoryGirl.create_list(:request, 10))
    end
    it "returns success with valid data" do
      get 'index'
      response.should be_success
    end
  end

end
