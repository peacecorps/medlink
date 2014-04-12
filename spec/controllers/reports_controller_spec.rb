require 'spec_helper'

describe ReportsController, :broken do

  let (:current_user) { FactoryGirl.create(:user) }
  before {
    sign_in current_user
  }

  describe "GET 'order_history'" do
    it "returns http success" do
      get :order_history, format: :csv
      response.should be_redirection
    end
  end

  describe "GET 'users'" do
    it "returns http success" do
      get :users, format: :csv
      response.should be_redirection
    end
  end

  describe "Missing specs" do
    it "order_history method"
    it "users method"
    it "pcmo_response_history method"
  end

end
