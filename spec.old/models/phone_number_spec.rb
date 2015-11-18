require "spec_helper"

describe Phone do
  it "validates country code" do
    n = Phone.new number: '(555) 555-5555'

    expect( n ).not_to be_valid

    msg = "Number should include a country code (e.g. +1 for the US)"
    expect( n.errors.full_messages ).to eq [msg]
  end
end
