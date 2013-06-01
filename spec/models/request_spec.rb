require 'spec_helper'

describe Request do
  subject { FactoryGirl.create :request }

  it 'can be created' do
    expect( subject ).to be_a_kind_of Request
  end
end
