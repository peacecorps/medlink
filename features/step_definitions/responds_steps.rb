When(/^I select a "(.*?)" request$/) do |request|
  all("#" + request + "-orders tbody tr")[0].click()
end

Then(/^I should be able to assign one action: "(.*?)"$/) do |action|
  choose("response_delivery_method_" + action.split[0].downcase)
end

Then(/^I should be able to assign a special instruction of (\d+) characters$/) do |char_count|
  fill_in "response_instructions", :with => "a" * char_count.to_i
end

Then(/^I should be able to assign a special instruction$/) do
  fill_in "response_instructions", :with => "a" * 160
end

When(/^I save my response$/) do
  click_button('Send Response')
#  save_page("/home/dell/resp_shot")
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
  pending_orders_in_table = [page.all('table#responded-orders tr').count - 1, 0].max
  pending_orders_in_table.should == expected_orders.to_i
end

Then(/^I should see the missing_delivery_method error message$/) do
  err_msg "Delivery method is missing"
end

Then(/^I should see the exceeds_char_limit error message$/) do
  err_msg "Instructions is too long (maximum is 160 characters)"
end

Then(/^I should see the replace_placeholder error message$/) do
  err_msg 'Instructions - Please replace the [placeholders] with values.'
end

Then(/^I should see the success error message$/) do
  pos_ack_msg "Success! Your response has been sent to"
end

Then(/^I should be able to assign "(.*?)" to special instruction$/) do |str|
  fill_in "response_instructions", :with => str
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
