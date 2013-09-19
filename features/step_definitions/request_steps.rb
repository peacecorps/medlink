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
  #NO: find_field('#order_supply_id > option:nth-child(2)').click
  #NO: find_field("option", :text => 'Gauze').click
  #YES: find_by_id('order_supply_id').click
  #NO: select("Gauze", :from => "input-group")
  #NO: select("Gauze", :from => "select select--full")
  #NO: select("Gauze", :from => "form__section")
  #NO/CLOSER: select("Gauze", :from => "order_supply_id")
  #NO: select("Gauze", :from => "order_supply_id")
  #NO: find('select').find('Gauze')
  #NO: find('select').find_field("option", :text => 'Gauze')
  #YES find('select').click
  #NO: find('#order_supply_id > option:nth-child(3)')
  #NO: puts find_field('#order_supply_id option[18]').text.inspect
  #YES: puts find_field('order_supply_id').text
  #YES puts find_field('order_supply_id').find('option[value]').text (same as previous line) 
  #YES: puts find(:xpath, ".//select[contains(@id, 'order_supply_id')]").text
  #NO: puts page.should have_xpath "//select[@id = 'order_supply_id']/option[18]"
  #NO: puts page.should have_xpath "//select[@id = 'order_supply_id']/option[@value='18']"
  #YES: puts page.should have_xpath "//select[@id = 'order_supply_id']"
  #YES: puts page.should have_xpath "//select[@id = 'order_supply_id']/option[@value]"
  #YES: puts page.should have_xpath "//select[@id = 'order_supply_id']/option[text()]"
  #NO:: puts page.should have_xpath "//select[@id = 'order_supply_id']/option[@value = '18']"
  #NO: find(:css, '.select select--full').find(:xpath, XPath::HTML.option("Gauze")).select_option
  #NO: puts find("//select[@id='order_supply_id']/option[18]/@value").inspect
  #YES: select(find(:xpath, "//*[@id='order_supply_id']/option[@value]").text, :from => "order_supply_id")
  #YES: find_by_id('order_supply_id').find('option[@value]').select_option
  #YES: puts find_field('order_supply_id').text
  #NO: puts find('option[value=Gauze]').text 
  #NO/CLOSER: select("18", :from => "order[supply_id]")
  #NO: page.select("5", :from => "order_supply_id")
  #NO: page.select("Bandage scissors", :from => "order_supply_id")
  #NO: page.select(Nokogiri::HTML("Bandage scissors").text, from: "order_supply_id")
  #NO: page.find_and_select_option("Bandage scissors")
  #NO: find_field('order_supply_id').click_link("Gauze")
  #NO: find_field('order_supply_id').click("Gauze")
  #NO: find_field('order_supply_id').find('option[@value=18]').inspect
  #NO: find("//select[@id = 'order_supply_id']/option[@value = '18']").inspect
  #NO: puts "LINE59=[" + find(:select, 'order_supply_id').all('option').find{|o| o.value=='18'}.inspect
  #NO: puts find(:select, 'order_supply_id').first(:option, '18').inspect
  #NO: select_box('order_supply_id').select('Gauze')
  #NO: find(:xpath, '//option[contains(text(), "Gauze")]', 'order_supply_id').select_option
  #............................................................
  #YES: puts find(:xpath, "//*[@id='order_supply_id']/option[@value]").text
  #YES: puts find_by_id('order_supply_id').find('option[@value]').text.inspect # gives "Supply Select"
#GOAL: How to add "18" or "Gauze" to previous line?
  puts find_by_id('order_supply_id').find('option[@value]').text.inspect # gives "Supply Select"
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

When(/^I give it all inputs with non\-number "(.*?)"$/) do |field|
  fill_in "Location", :with => "loc valid inputs"
  fill_in "Units",    :with => "mg"
  if (field == "Quantity")
    fill_in "Quantity", :with => "BADVALUE" #WRONG
  else
    fill_in "Quantity", :with => "1"
  end
  fill_in "Special instructions area", :with => "S/I/A valid"
  select_supply
  click_button "Submit"
end

#P9 (SUCCESS)
Then(/^I see a successful request message$/) do
save_and_open_page #FIXME
  page.should have_selector ".alert", text: "Order submitted successfully."
end

Then(/^I see a invalid supply request message$/) do
  page.should have_content "shortcode unrecognized"
end

Then(/^I see a invalid "(.*?)" request message$/) do |field| 
  page.should have_content "#{field} is Missing"
end

Then(/^I see a nonnumber "(.*?)" request message$/) do |field|
  page.should have_content "#{field} is not a number"
end
#save_and_open_page
