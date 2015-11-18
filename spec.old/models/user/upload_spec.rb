require 'spec_helper'

describe User::Upload do
  def upload csv
    # TODO: support country lookup?
    country = create :country
    io      = StringIO.new csv
    @upload = User::Upload.new country: country
    @upload.run! io
  end

  it "created phone numbers" do
    upload File.read Rails.root.join "spec/data/users.good.csv"
    a,b,c = %w(a b c).map { |n| User.where(email: "#{n}@example.com").first! }
    expect( a.phones.count ).to eq 1
    expect( b.phones.count ).to eq 2
    expect( c.phones.count ).to eq 0
  end

  it "rejects CSVs without a header row" do
    upload "a@example.com,111,,A,Person"
    expect( @upload.global_errors.first.message ).to match /missing header/i
  end

  it "rejects CSVs with bad headers" do
    upload "email,not_a_field\na@example.com,nope"

    errs = @upload.headers.select(&:errors).map(&:value)
    expect( errs ).to eq ["not_a_field"]
  end
end
