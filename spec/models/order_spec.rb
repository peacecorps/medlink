require 'spec_helper'

describe Order do

  before :each do
    FactoryGirl.create :user,   pcv_id: 'USR'
    FactoryGirl.create :supply, shortcode: 'BND', name: 'Bandages'
    FactoryGirl.create :supply, shortcode: 'SND', name: 'Second thing'
  end

  context 'from text' do

    let(:data) { { pcvid: 'USR', loc: 'LOC', shortcode: 'BND',
      phone: '555-123-4567', qty: 1, dosage_value: 11, dosage_units: 'mg' } }

    subject { Order.create_from_text data }

    its(:email) { should match /user\d+@example.com/ }
    its(:phone) { should eq '555-123-4567'     }

    it { should_not be_fulfilled }

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
      end.to raise_error /unrecognized shortcode/i
    end

    it 'can display a validation message' do
      subject.supply = nil
      expect( subject.confirmation_message ).to match /shortcode/i
    end

  end

  # -----

  context 'from web' do
    let(:data) { {
      email:     'custom@example.com',
      phone:     'N/A',
      supply_id: Supply.first.id,
      dose:      10,
      unit:      'mg',
      location:  'Roswell',
      quantity:  1
    } }

    it 'can print its full dosage' do
      order = FactoryGirl.create :order, data
      expect( order.full_dosage ).to eq '10mg'
    end

    it 'rejects duplicates' do
      # Sequences generate different Users if we don't do this:
      d = data.merge user_id: User.first.id

      expect do
        Order.create! d
        Order.create! d
      end.to raise_error /supply has already been taken/i
    end

  end

end
