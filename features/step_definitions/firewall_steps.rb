# config.allowed_ips = ['127.0.0.1']

Given(/^I'm outside the firewall$/) do
  pending "TODO: Add Code"
end

Given(/^I'm inside the firewall$/) do
  pending "TODO: Add Code"
end

Then(/^I get an error message: "(.*?)"$/) do |msg|
  page.should_not have_content 'error' # FIXME
end

Then(/^I should see no error$/) do
  page.should_not have_content 'error'
end

