require "spec_helper"

describe Phone do
  it "validates country code" do
    n = Phone.new number: '(555) 555-5555'

    expect( n ).not_to be_valid
    expect( n.errors.full_messages ).to eq ["Number should include a country code"]
  end
end
