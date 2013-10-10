Then /^I should see the image "(.+)"$/ do |image|
  page.should have_xpath("//img[@id=\"#{image}\"]")
end

Then /^I should see the button "(.+)"$/ do |button|
  find_button(button).visible?
end

Then /^I should see field "(.+)"$/ do |value|
  find_field(value).visible?
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^I should see link "(.+)"$/ do |value|
  find_link(value).visible?
end

Then /^I should see tab "(.+)"$/ do |tab|
  page.should have_content tab
end

Then /^I should see column "(.*?)"$/ do |column|
  find("th", :text => column).visible?
end

Then(/^I should see (\d+) columns of "(.*?)"$/) do |thecount, column|
  page.should have_css("th", :text => column, :count => thecount)
end

Then /^I should see dropdownmenu "(.*?)"$/ do |menu|
  find("option", :text => menu).visible?
end

Then /^I should see header with text "(.*?)"$/ do |header_text|
  page.should have_css("h1,h2,h3,h4,h5", :text => header_text)
end

Then /^I should see div with text "(.*?)"$/ do |the_text|
  page.should have_css("div", :text => the_text)
end

Then(/^I should see radiobutton "(.*?)"$/) do |rbutton|
  find("li", :text => rbutton).visible?
end
