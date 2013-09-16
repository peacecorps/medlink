def select_supply
  #FIXME: Add "Select Supply"
  #find_by_id("order_supply_id").find("Gauze").click # Select Supply
  #find_field('#order_supply_id option[18]').click # Select Supply
  #NO: find_field('#new_order option[18]').select_option
  #find_by_id('order_supply_id').find('option value="18"').click
  #find_by_id("order_supply_id").find("option", :text => "Gauze")
  #find_field('order_supply_id').find('option[18]').click
  #select("Eye drops", :from => "order_supply_id")
  #order_supply_id > option:nth-child(7)
  #
  #supply_list = Set.new Supply.where(name: "Gauze").first!.users.pcmos.pluck :id
  #options = page.all('#user_pcmo_id optgroup option').reduce(Set.new) do |s,o|

  #NO: page.select("18", :from => "order[supply_id]")
  #NO: page.execute_script("$('#order_supply_id').val('Gauze')")
  #NO: find(:select, "order[supply_id]", "Select Supply").find(:option, "18", "Select Supply").select_option
  #NO: page.select("Gauze", :from => "order[supply_id]")
  #NO: within '#order_supply_id' do ; find("option[value='18']").click ; end
  #NO: select(find(:xpath, "//*[@name='order[supply_id]']/option[@value='18']").text, :from => 'order_supply_id')
  #NO: find_by_id('order_supply_id').find("Gauze").select_option

  find_field('#order_supply_id > option:nth-child(2)').click
end

When(/^I place a request$/) do
  visit '/orders/new'
end

When(/^I give it all inputs but "(.*?)"$/) do |field|
  fill_in "Location", :with => "loc but arg"
  fill_in "Units",    :with => "mg"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area",  :with => "S/I/A but"
  case field
  when "Select Supply"
    # Do nothing for "Select Supply"
  end
  click_button "Submit"
end

When(/^I give it all inputs but location$/) do
  # FYI: Do nothing for "Locaton"
  fill_in "Units",    :with => "mg"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area",  "S/I/A location"
  select_supply
  click_button "Submit"
end

When(/^I give it all inputs but quantity$/) do
  fill_in "Location", :with => "loc but quantity"
  fill_in "Units",    :with => "mg"
  # FYI: Do nothing for "Quantity"
  fill_in "Special instructions area",  :with => "S/I/A qty"
  select_supply
  click_button "Submit"
end

When(/^I give it all inputs but units$/) do
  fill_in "Location", :with => "loc but units"
  # FYI: Do nothing for "Units"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area",  :with => "S/I/A but units"
  select_supply
  click_button "Submit"
end

When(/^I give it all the valid inputs$/) do
  fill_in "Location", :with => "loc valid inputs"
  fill_in "Units",    :with => "mg"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area", :with => "S/I/A valid"
  select_supply
  click_button "Submit"
end

#P9 (SUCCESS)
Then(/^I see a successful request message$/) do
save_and_open_page  
  page.should have_selector ".alert", text: "Order submitted successfully."
end

Then(/^I see a invalid supply request message$/) do
  page.should have_content "shortcode unrecognized"
end

Then(/^I see a invalid "(.*?)" request message$/) do |field| 
  page.should have_content "#{field} is Missing"
end
#save_and_open_page
