require 'spec_helper'

describe Request do
  subject { FactoryGirl.create :request }

  it 'can be created' do
    expect( subject ).to be_a_kind_of Request
  end

  context 'validation' do
    pending 'spec any non-trivial validations'
  end

  context 'received' do
    it { should_not be_confirmed }

    it 'notifies if invalid'
    it 'rejects duplicates'

    it 'knows its email destination for text messages' do
      expect( subject.destination.keys ).to eq [:email, :phone]
    end

    context 'when valid' do
      it { should be_valid }

      it 'can generate a confirmation message' do
        expect( subject.confirmation_message ).to match /has been processed/
      end
    end

    context 'when invalid' do
      before(:each) { subject.pcv_id = nil }

      it { should_not be_valid }

      it 'can generate an error message' do
        expect( subject.confirmation_message ).to match /pcv id/i
      end
    end
  end

  context 'confirmed' do
    before(:each) { subject.confirm! }

    it { should be_confirmed }
    it { should_not be_complete }

    it 'can be completed'
  end

  context 'completed' do
    it { should be_complete }

    it 'has instructions for pickup'
    it 'can send those instructions'
  end
end
