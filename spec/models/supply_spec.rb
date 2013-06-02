require 'spec_helper'

describe Supply do
  subject { FactoryGirl.create :supply, name: 'Supply item', shortcode: 'SPPLY' }

  it { should be_a_kind_of Supply }

  it 'knows what unit options it accepts'

  context 'lookup' do
    before(:each) { FactoryGirl.create :supply, name: 'Lookup', shortcode: 'LOOK' }

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
