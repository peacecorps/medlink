When(/^I select a "(.*?)" request$/) do |request|
  # within(request).click on 1s item.
  first(".orders > td").click
  pending #FIXME: Write code.
end

Then(/^I should be able to assign one of four actions: "(.*?)"$/) do |action|
  # GOAL: click on one of the radio buttons
  #     -- first('.list_column').click_link(action)
  pending #FIXME: Write code.
end

When(/^I save my response$/) do
  # GOAL: Check value in database.
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

Then(/^I should have (\d+) pending orders to process$/) do |expected_orders|
  pending_orders_in_table = page.all('table#pending-orders tr').count - 1
  pending_orders_in_table.should == expected_orders.to_i
end
