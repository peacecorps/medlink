require 'spec_helper'

describe Request do
  subject { FactoryGirl.create :request }

  it { should be_a_kind_of Request }
end
