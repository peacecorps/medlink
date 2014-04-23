require "spec_helper"

describe PhoneNumber do
  it "validates country code" do
    n = PhoneNumber.new display: '(555) 555-5555'

    expect( n ).not_to be_valid
    expect( n.errors.full_messages ).to eq ["Display should include a country code"]
  end
end
