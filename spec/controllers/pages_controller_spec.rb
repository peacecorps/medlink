require 'spec_helper'

describe PagesController do
  describe "GET /" do
    it 'redirects to orders' do
      get 'root'
      expect( response ).to be_redirection
    end
  end
end
