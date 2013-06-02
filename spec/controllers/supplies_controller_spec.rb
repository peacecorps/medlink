require 'spec_helper'

describe SuppliesController do
  let (:current_user) { FactoryGirl.create(:user) }
  before {
    sign_in current_user
  }

  describe "GET 'index'" do
    before do
      FactoryGirl.create_list(:supply,30)
    end
    it "returns success with valid data" do
      get 'index', format: :json
      response.should be_success
    end
  end

end
