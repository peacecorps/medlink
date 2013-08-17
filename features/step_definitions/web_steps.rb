Then /^I should see the image "(.+)"$/ do |image|
  page.should have_xpath("//img[@id=\"#{image}\"]")
end

Then /^I should see the button "(.+)"$/ do |button|
  find_button(button).visible?
end

Then /^I should see "(.+)" inside "(.+)"$/ do |value, tag|
  find(tag, :text => value).visible?
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
