When(/^I select a "(.*?)" request$/) do |request|
#DEBUG: puts all("#" + request + "-orders tbody tr")[0].text
  all("#" + request + "-orders tbody tr")[0].click()
  visit('3/edit') #FIXME: above click problem
#FIXME: The table row "click" above does not work
end

Then(/^I should be able to assign one of four actions: "(.*?)"$/) do |action|
  choose(action)
end

When(/^I save my response$/) do
  # GOAL: Check value in database.
  click_button('Send Response')
end

Then(/^I should see the response date and PCMO id on the request$/) do
  visit('orders/manage')
  pending #FIXME: manage_orders page does not have order

end

Then(/^I should have (\d+) pending orders to process$/) do |expected_orders|
  pending_orders_in_table = page.all('table#pending-orders tr').count - 1
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
