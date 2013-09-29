When(/^I select a "(.*?)" request$/) do |request|
  all("#" + request + "-orders tbody tr")[0].click()
end

Then(/^I should be able to assign one of four actions: "(.*?)"$/) do |action|
  choose(action)
end

When(/^I save my response$/) do
  click_button('Send Response')
  save_page("/home/dell/resp_shot")
end

Then(/^I should see the response date and PCMO id "(.*)" on the request$/) do |pcmo_id|
  # FYI: Month/Day have no-padding.
  all('table#responded-orders tr td')[8].should have_content( DateTime.now.strftime("%-m/%-d/%y") )
  all('table#responded-orders tr td')[0].should have_content( pcmo_id )
end

Then(/^I should have (\d+) pending orders to process$/) do |expected_orders|
  pending_orders_in_table = page.all('table#pending-orders tr').count - 1
  pending_orders_in_table.should == expected_orders.to_i
end

Then(/^I should have (\d+) past due orders to process$/) do |expected_orders|
  pending_orders_in_table = page.all('table#past-due-orders tr').count - 1
  pending_orders_in_table.should == expected_orders.to_i
end

Then(/^I should have (\d+) response tracker orders$/) do |expected_orders|
  pending_orders_in_table = page.all('table#responded-orders tr').count - 1
  pending_orders_in_table.should == expected_orders.to_i
end

######################################################################

Given(/^I select a request that another PCMO has responded to$/) do
  pending #FIXME: Write code.
end

Then(/^I should see a message that the request has been handled$/) do
  pending #FIXME: Write code.
end

Then(/^I should see the other PCMO's id on the request$/) do
  pending #FIXME: Write code.
end
#save_and_open_page
