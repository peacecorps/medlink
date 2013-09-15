require 'pry'

Then(/^I should see the add user form$/) do
  expect( page ).to have_css 'form#new_user'
end

When(/^I choose a "(.*?)" role$/) do |role|
  select role, from: 'user_role'
end

Then(/^I should not see the PCMO select box$/) do
  !find_field('user_pcmo_id').visible?
end

When(/^I choose the country "(.*?)"$/) do |name|
  select name, from: 'user_country_id'
end

Then(/^I should see the PCMO select box$/) do
  find_field('user_pcmo_id').visible?
end

When(/^I fill out the add user form$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a "(.*?)" confirmation$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I change first_name to $/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a required error message$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change last_name to $/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change country to $/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change location to $/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change phone to $/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change pcv_id to $/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change pcv_id to (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a unique error message$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I change email to nope$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a invalid error message$/) do
  pending # express the regexp above with the code you wish you had
end
