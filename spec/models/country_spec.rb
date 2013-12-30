require 'spec_helper'

describe Country do

  before :each do
    4.times do
      FactoryGirl.create(:country)
    end
  end
  
  it 'should have a to_s method that provides the country name' do
    afghanistan = FactoryGirl.create(:country, name: "Afghanistan")
    expect(afghanistan.to_s).to eq(afghanistan.name)
  end

  it 'should list choices mapped by name and id for all countries' do
    fifth_country = FactoryGirl.create(:country, name: "Australia")
    test_choices = Country.choices
    expect(test_choices.count).to eq(5)
    expect(test_choices.last).to include(fifth_country.name && fifth_country.id)
  end

  it "should have a with_orders method that only returns countries with orders" do
    usa = FactoryGirl.create(:country, name: "America")
    brazil = FactoryGirl.create(:country, name: "Brazil")
    american_user = FactoryGirl.create(:user, country: usa)
    brazilian_user = FactoryGirl.create(:user, country: brazil)
    american_order = FactoryGirl.create(:order, user: american_user)
    expect(Country.with_orders).to include(usa)
    expect(Country.with_orders).to_not include(brazil)
    brazilian_order = FactoryGirl.create(:order, user: brazilian_user)
    expect(Country.with_orders).to include(brazil)
    expect(Country.with_orders.count).to eq(2)
  end
end
