require 'spec_helper'

describe User do
  subject { FactoryGirl.create :user }

  it 'can be created' do
    expect( subject ).to be_a_kind_of User
  end
end
