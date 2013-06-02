require 'spec_helper'

describe Order do

  before :each do
    FactoryGirl.create :user,   pcv_id: 'USR'
    FactoryGirl.create :supply, shortcode: 'BND'
    FactoryGirl.create :supply, shortcode: 'SND'
  end
  
  context 'validation' do
    pending 'spec validation messages'
  end

  context 'from text' do

    let(:data) { { pcvid: 'USR', loc: 'LOC', shortcode: 'BND', phone: '555-123-4567' } }

    subject { Order.create_from_text data }

    it { should be_a_kind_of Order }

    its(:email) { should match /user\d+@example.com/ }
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
    let(:data) { {
      email: 'custom@example.com',
      phone: 'N/A',
      requests_attributes: [{
        supply_id: Supply.first.id,
        dose:      '10mg'
      }, {
        supply_id: Supply.last.id,
        quantity:  5
      }]
    } }

    subject { FactoryGirl.create :order, data }
    after(:each) { subject.destroy }

    it { should be_a_kind_of Order }
    it { should_not be_confirmed   }

    it 'requires unique supply items'

    it 'rejects duplicates' do
      # Sequences generate different Users if we don't do this:
      d = data.merge user_id: User.first.id

      expect do
        Order.create! d
        Order.create! d
      end.to raise_error /duplicate/i
    end

    its(:email) { should eq 'custom@example.com' }
    its(:phone) { should eq 'N/A'                }

    context 'when valid' do
      it { should be_valid }

      it 'can generate a confirmation message' do
        expect( subject.confirmation_message ).to match /has been processed/
      end
    end

    context 'when invalid' do
      before(:each) { subject.user = nil }

      it { should_not be_valid }

      it 'can generate an error message' do
        expect( subject.confirmation_message ).to match /pcv id/i
      end
    end

    context 'confirmed' do
      before(:each) { subject.confirm! }

      it { should be_confirmed }
      it { should_not be_fulfilled }
    end

    context 'fulfilled' do
      before(:each) { subject.fulfill! 'Look around you' }

      it { should be_fulfilled }
      its(:instructions) { should eq 'Look around you' }
    end

  end

end