require 'spec_helper'

describe ReportsController do

  describe "GET 'reports'" do
    pending 'Add specs for GET reports'
  end

=begin
  describe "GET 'reports'" do
    it 'displays a template' do
      rslt = ReportsController.request_history
      puts rslt.inspect
      #expect( response ).to be_success
    end
  end

  describe "request_history" do
    it "@orders is none zero" do
      request_history_reports_path(format: :csv).should be 0
    end
  end

  describe "GET 'request_history'" do
    it "returns http success" do
      get request_history_reports_path(format: :csv)
      response.should be_success
    end
  end

  describe "GET 'fulfillment_history'" do
    it "returns http success" do
      get 'fulfillment_history'
      response.should be_success
    end
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
=end

end
