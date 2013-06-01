require 'spec_helper'

describe Order do

  context 'from text' do
    subject { Order.from_text }

    it { should be_a_kind_of Order }

    context 'validation' do
      pending 'spec and non-trivial validations'
    end

    it 'knows its response destination' do
      expect( subject.destination.keys ).to eq [:email, :phone]
    end
  end

  # -----

  context 'from web' do
    subject { FactoryGirl.create :order }  

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

    context 'confirmed' do
      before(:each) { subject.confirm! }

      it { should be_confirmed }
      it { should_not be_complete }

      it 'can be completed'
    end

    context 'fulfilled' do
      it { should be_fulfilled }

      it 'has instructions for pickup'
    end
  end

end