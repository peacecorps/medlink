require 'spec_helper'

describe User::Upload do
  before :all do
    # TODO: should the upload take country as an argument?
    country = FactoryGirl.create :country
    csv = <<-EOS
email,phone,phone2,first_name,last_name,pcv_id,country_id,role,location,time_zone
a@example.com,1111111,,A,Person,123,#{country.id},pcv,A Place,UTC
b@example.com,(222) 222-2222,333-3333,B,Person,456,#{country.id},pcv,B Place,UTC
c@example.com,,,C,Person,789,#{country.id},pcv,C Place,UTC
d@example.com,,,Error,Person,,,,,
    EOS

    @upload = User::Upload.new StringIO.new(csv)
    @upload.run!
  end
  after(:all) { [Country, User, PhoneNumber].each &:delete_all }

  it "created phone numbers" do
    a,b,c = %w(a b c).map { |n| User.where(email: "#{n}@example.com").first! }
    expect( a ).to have(1).phone_numbers
    expect( b ).to have(2).phone_numbers
    expect( c ).to have(0).phone_numbers
  end
end
