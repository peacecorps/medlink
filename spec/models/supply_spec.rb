require 'spec_helper'

describe Supply do
  subject { FactoryGirl.create :supply, name: 'Supply item',
    shortcode: 'SPPLY' }

  it 'can be printed' do
    expect( subject.to_s ).to eq 'Supply item'
  end

  it 'knows its choices' do
    malformed = Supply.choices.find { |choice| choice.length != 2 }
    expect( malformed ).to be nil
  end

  it 'knows its unit choices' do
    malformed = Supply.units.find { |choice| choice.length != 2 }
    expect( malformed ).to be nil
  end

  context 'lookup' do
    before(:each) { FactoryGirl.create :supply, name: 'Lookup',
      shortcode: 'LOOK' }

    it 'retrieves upper case' do
      expect( Supply.lookup 'LOOK' ).to be_present
    end

    it 'retrieves lower case' do
      expect( Supply.lookup 'look' ).to be_present
    end

    it 'retieves by name' do
      expect( Supply.lookup 'lookup' ).to be_present
    end
  end
end
