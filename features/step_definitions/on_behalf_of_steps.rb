When(/^I place an order for "(.*?)"$/) do |first_name|
  pcv_id = User.find_by_first_name(first_name).id
  steps %{
    And that the following orders have been made
      | pcv       | supply |
      | #{pcv_id} | GAUZE  |
  }
end

Then(/^I should see an order for "(.*?)" in the queue$/) do |user_id|
  Order.exists?(:user_id => user_id) == true
end

Then(/^I should see a pcmo dropdown containing only "(.*?)"$/) do |text|
  page.should have_selector "select", text: text
end

And(/^I should not see a pcmo dropdown containing "(.*?)"$/) do |text|
  page.should_not have_selector "select", text: text
end

Then(/^I should see a pcmo dropdown containing both "(.*?)" and "(.*?)"$/) do |first, second|
  page.should have_selector "select", text: first
  page.should have_selector "select", text: second
end
