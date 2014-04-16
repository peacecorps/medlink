require 'spec_helper'

describe User::Upload do
  upload = ->(csv) { User::Upload.new(StringIO.new csv).run!  }

  before :all do
    # TODO: should the upload take country as an argument?
    country = create :country
    csv = <<-EOS
email,phone,phone2,first_name,last_name,pcv_id,country_id,role,location,time_zone
a@example.com,1111111,,A,Person,123,#{country.id},pcv,A Place,UTC
b@example.com,(222) 222-2222,333-3333,B,Person,456,#{country.id},pcv,B Place,UTC
c@example.com,,,C,Person,789,#{country.id},pcv,C Place,UTC
d@example.com,,,Error,Person,,,,,
    EOS

    upload.(csv)
  end
  after(:all) { [Country, User, PhoneNumber].each &:delete_all }

  it "created phone numbers" do
    a,b,c = %w(a b c).map { |n| User.where(email: "#{n}@example.com").first! }
    expect( a ).to have(1).phone_numbers
    expect( b ).to have(2).phone_numbers
    expect( c ).to have(0).phone_numbers
  end

  it "rejects CSVs without a header row" do
    expect do
      upload.("a@example.com,111,,A,Person")
    end.to raise_error /missing header/i
  end

  it "rejects CSVs with bad headers" do
    expect do
      upload.("email,not_a_field\na@example.com,nope")
    end.to raise_error /unrecognized header/i
  end
end
