require 'spec_helper'

describe Request do
  subject { FactoryGirl.create :request }

  it 'can be created' do
    expect( subject ).to be_a_kind_of Request
  end

  context 'received' do
    it 'has not been confirmed' do
      expect( subject ).not_to be_confirmed
    end

    it 'can send a confirmation'
    it 'notifies if invalid'
    it 'rejects duplicates'
  end

  context 'confirmed' do
    before(:each) { subject.confirm! }

    it 'has been confirmed' do
      expect( subject ).to be_confirmed
    end

    it 'has not been completed' do
      expect( subject ).not_to be_complete
    end

    it 'can be completed'
  end

  context 'completed' do
    it 'is complete' do
      expect( subject ).to be_complete
    end

    it 'has instructions for pickup'
    it 'can send those instructions'
  end
end
