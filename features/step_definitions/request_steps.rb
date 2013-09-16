When(/^I place a request$/) do
  visit '/orders/new'
end

When(/^I give it all inputs but "(.*?)"$/) do |field|
  case field
  when "Select Supply"
    # Do nothing for "Select Supply"
  end
  fill_in "Location", :with => @user[:location]
  fill_in "Units",    :with => @user[:units]
  fill_in "Quantity", :with => @user[:qty]
  fill_in "Special instructions area",  :with => @user[:special]
  click_button "Submit"
end

When(/^I give it all inputs but location$/) do
  #FIXME: Add "Select Supply"
  # FYI: Do nothing for "Locaton"
  fill_in "Units",    :with => @user[:units]
  fill_in "Quantity", :with => @user[:qty]
  fill_in "Special instructions area",  :with => @user[:special]
  click_button "Submit"
end

When(/^I give it all inputs but quantity$/) do
  #FIXME: Add "Select Supply"
  fill_in "Location", :with => @user[:location]
  fill_in "Units",    :with => @user[:units]
  # FYI: Do nothing for "Quantity"
  fill_in "Special instructions area",  :with => @user[:special]
  click_button "Submit"
end

When(/^I give it all inputs but units$/) do
  #FIXME: Add "Select Supply"
  fill_in "Location", :with => @user[:location]
  # FYI: Do nothing for "Units"
  fill_in "Quantity", :with => @user[:qty]
  fill_in "Special instructions area",  :with => @user[:special]
  click_button "Submit"
end

#P9 (SUCCESS)
Then(/^I see a successful request message$/) do
  page.should have_selector ".alert", text: "Order submitted successfully."
end

Then(/^I see a invalid supply request message$/) do
  page.should have_content "shortcode unrecognized"
end

Then(/^I see a invalid "(.*?)" request message$/) do |field| 
  page.should have_content "#{field} is Missing"
end

When(/^I give it all the valid inputs$/) do
  #find_by_id("order_supply_id").find("Gauze").click # Select Supply
  #find_field('#order_supply_id option[18]').click # Select Supply
  #find_by_id("order_supply_id").find("option", :text => "Gauze")
  #find_field('order_supply_id').find('option[18]').click
  #select("Eye drops", :from => "order_supply_id")
  fill_in "Location", :with => @user[:location]
  fill_in "Units",    :with => @user[:units]
  fill_in "Quantity", :with => @user[:qty]
  fill_in "Special instructions area",  :with => @user[:special]
  click_button "Submit"
end
#save_and_open_page
