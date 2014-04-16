require 'spec_helper'

describe Supply do
  before :each do
    create :supply, name: 'Item', shortcode: 'ITEM'
  end

  it 'knows its choices' do
    expect( Supply.choices ).to eq [['Item', Supply.last.id]]
  end

  context 'can query' do
    it 'upcase' do
      expect( Supply.find_by_shortcode 'ITEM' ).to be_a Supply
    end

    it 'downcase' do
      expect( Supply.find_by_shortcode 'item' ).to be_a Supply
    end

    it 'failure' do
      expect{ Supply.find_by_shortcode 'nope' }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
