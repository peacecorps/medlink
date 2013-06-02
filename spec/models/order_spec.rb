require 'spec_helper'

describe Order do

  before :each do
    FactoryGirl.create :user,   pcv_id: 'USR'
    FactoryGirl.create :pc_hub, name: 'LOC'
    FactoryGirl.create :supply, shortcode: 'BND'
  end
  
  context 'validation' do
    pending 'spec and non-trivial validations'
  end

  context 'from text' do

    let(:data) { { pcvid: 'USR', loc: 'LOC', shortcode: 'BND', phone: '555-123-4567' } }

    subject { Order.create_from_text data }

    it { should be_a_kind_of Order }

    its(:email) { should eq 'user@example.com' }
    its(:phone) { should eq '555-123-4567'     }

    it 'raises on invalid pcvid' do
      expect do 
        data[:pcvid] = 'NON'
        Order.create_from_text data
      end.to raise_error /unrecognized pcvid/i
    end

    it 'with invalid shortcode' do
      expect do
        data[:shortcode] = 'NON'
        Order.create_from_text data
      end.to raise_error  /unrecognized shortcode/i
    end

  end

  # -----

  context 'from web' do

    subject { FactoryGirl.create :order,
      email: 'custom@example.com', 
      phone: '-'
    }  

    it { should be_a_kind_of Order }
    it { should_not be_confirmed   }

    it 'rejects duplicates' do
      # Add two requests to order
      # Create duplicate order
    end

    its(:email) { should eq 'custom@example.com' }
    its(:phone) { should eq '-'                  }

    context 'when valid' do
      it { should be_valid }

      it 'can generate a confirmation message' do
        expect( subject.confirmation_message ).to match /has been processed/
      end
    end

    context 'when invalid' do
      before(:each) { subject.pc_hub = nil }

      it { should_not be_valid }

      it 'can generate an error message' do
        expect( subject.confirmation_message ).to match /location code/i
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