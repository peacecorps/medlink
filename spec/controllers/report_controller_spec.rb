require 'spec_helper'

describe ReportController do

  describe "GET 'request_history'" do
    it "returns http success" 
#TODO# do
#TODO#       get 'request_history'
#TODO#       response.should be_success
#TODO#     end
  end

  describe "GET 'fulfillment_history'" do
    it "returns http success" 
#TODO# do
#TODO#       get 'fulfillment_history'
#TODO#       response.should be_success
#TODO#     end
  end

  describe "GET 'recent_adds'" do
    it "returns http success" do
      get 'recent_adds'
      response.should be_success
    end
  end

  describe "GET 'recent_edits'" do
    it "returns http success" do
      get 'recent_edits'
      response.should be_success
    end
  end

  describe "GET 'pcmo_response_times'" do
    it "returns http success" do
      get 'pcmo_response_times'
      response.should be_success
    end
  end

  describe "GET 'supply_history'" do
    it "returns http success" do
      get 'supply_history'
      response.should be_success
    end
  end

end
