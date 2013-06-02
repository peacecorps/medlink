require 'spec_helper'

describe OrdersController do
  let (:current_user) { FactoryGirl.create(:user) }
  before {
    sign_in current_user
  }

  describe "POST 'create'" do
    let (:pc_hub) { FactoryGirl.create(:pc_hub) }
    it "returns http success" do
      post 'create', order: {user_id: current_user.id, pc_hub_id: pc_hub.id}
      puts response.body
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    let :example do
      FactoryGirl.create(:order, user_id: current_user.id)
    end
    it "returns http success" do
      delete 'destroy', id: example.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    let :example do
      FactoryGirl.create(:order, user_id: current_user.id)
    end
    it "returns http success" do
      put :update, id: example.id, order: {phone: '678-315-5999'}
      response.should be_success
    end
  end

end
