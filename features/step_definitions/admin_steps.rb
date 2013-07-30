Given(/^I am inside the firewall$/) do
  pass
  #TODO: Add Code.
end

Then(/^I should see add user form$/) do
  steps %{
    Then I should see "Add User" inside "h2"
  }
end

When(/^I fill out user inputs$/) do
  fill_in "First Name", :with => @visitor[:first_name]
  fill_in "Last Name", :with => @visitor[:last_name]
  fill_in "Address/location", :with => "Roswell"
#TODO: select Country
  fill_in "PCV ID", :with => "11111111"
#TODO: select Role
  fill_in "email@email.com", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Add"
end

Then(/^I should see a confirmation dialog$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^user should be created$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I choose a country "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should have a pick list of PCMOs in that country: "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I check for a missing field: "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should get error message on top of form$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^see Erroneous fields should be highlighted$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I enter a duplicate "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should get a message saying so$/) do
  pending # express the regexp above with the code you wish you had
end
