require 'spec_helper'

describe ApplicationController do
  describe "GET /" do
    it 'redirects to orders' do
      get 'root'
      expect( response ).to be_redirection
    end
  end
end
