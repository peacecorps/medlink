require 'spec_helper'

describe Supply do
  subject { FactoryGirl.create :supply }

  it { should be_a_kind_of Supply }

  it 'knows what unit options it accepts'
end
