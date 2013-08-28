Given(/^that "(.*?)" is a country$/) do |name|
  FactoryGirl.create :country, name: name
end
