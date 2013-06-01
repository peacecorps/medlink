require 'spec_helper'

describe Supply do
  subject { FactoryGirl.create :supply }

  it 'can be created' do
    expect( subject ).to be_a_kind_of Supply
  end
end
