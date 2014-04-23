require 'spec_helper'

describe User::Upload do
  def upload csv
    # TODO: support country lookup?
    country = create :country
    io      = StringIO.new csv
    @upload = User::Upload.new country, io
    @upload.run!
  end

  it "created phone numbers" do
    upload File.read Rails.root.join "spec/data/users.csv"
    a,b,c = %w(a b c).map { |n| User.where(email: "#{n}@example.com").first! }
    expect( a ).to have(1).phones
    expect( b ).to have(2).phones
    expect( c ).to have(0).phones
  end

  it "rejects CSVs without a header row" do
    expect do
      upload "a@example.com,111,,A,Person"
    end.to raise_error /missing header/i
  end

  it "rejects CSVs with bad headers" do
    expect do
      upload "email,not_a_field\na@example.com,nope"
    end.to raise_error /unrecognized header/i
  end
end
