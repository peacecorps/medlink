When(/^I select a "(.*?)" request$/) do |request|
  pending #FIXME: Write code.
end

Then(/^I should be able to assign one of four actions: "(.*?)"$/) do |action|
  pending #FIXME: Write code.
end

When(/^I save my response$/) do
  pending #FIXME: Write code.
end

Then(/^I should see the response date and PCMO id on the request$/) do
  pending #FIXME: Write code.
end

Given(/^I select a request that another PCMO has responded to$/) do
  pending #FIXME: Write code.
end

Then(/^I should see a message that the request has been handled$/) do
  pending #FIXME: Write code.
end

Then(/^I should see the other PCMO's id on the request$/) do
  pending #FIXME: Write code.
end

Then(/^I should have (\d+) orders to process$/) do |expected_orders|
  number_of_orders_in_table = page.all('table#orders tr').count - 1
  number_of_orders_in_table.should == expected_orders.to_i
end
