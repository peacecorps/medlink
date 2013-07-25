require 'spec_helper'

describe ApplicationController do
  describe "GET /" do
    it 'redirects to orders' do
      get 'root'
      expect( response ).to be_redirection
    end
  end

  describe "GET /help" do
    pending 'displays a help template' do
      get 'help'
      expect( response ).to be_success
    end
  end
end