require 'spec_helper'

describe RequestsController do

  describe "GET 'create'" do
    it "returns http success" do
      post 'create', dose: 'some_string', quantity: 5 
      response.should be_success
      req = JSON.parse(response.body)
      req["request"]["dose"].should eq 'some_string'
    end
  end

  describe "GET 'destroy'" do
    let :example do
      FactoryGirl.create(:request)
    end
    it "returns http success" do
      delete 'destroy', id: example.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    let :example do
      FactoryGirl.create(:request)
    end
    it "returns http success" do
      put :update, id: example.id
      response.should be_success
    end
  end

end
