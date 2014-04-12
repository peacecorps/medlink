require 'spec_helper'

describe ApplicationController, :broken do
  describe "GET /" do
    it 'redirects to orders' do
      get 'root'
      expect( response ).to be_redirection
    end
  end

  describe "GET /help" do
    it 'displays a help template' do
      get 'help'
      expect( response ).to be_success
    end
  end
end
