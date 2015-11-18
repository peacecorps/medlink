require 'spec_helper'

describe Country do
  before :each do
    4.times { create(:country) }
  end

  it 'should list choices mapped by name and id for all countries' do
    aus = create(:country, name: "Aaaaaustralia")
    test_choices = Country.choices
    expect(test_choices.count).to eq(Country.count)
    expect(test_choices.first).to eq [aus.name, aus.id]
  end

  it "should have a with_orders method that only returns countries with orders" do
    usa = create(:country, name: "America")
    brazil = create(:country, name: "Brazil")
    american_user = create(:user, country: usa)
    brazilian_user = create(:user, country: brazil)
    american_order = create(:order, user: american_user)
    expect(Country.with_orders).to include(usa)
    expect(Country.with_orders).to_not include(brazil)
    brazilian_order = create(:order, user: brazilian_user)
    expect(Country.with_orders).to include(brazil)
    expect(Country.with_orders.count).to eq(2)
  end
end
