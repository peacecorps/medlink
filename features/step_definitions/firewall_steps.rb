Given(/^I'm outside the firewall$/) do
  # Next line is done to simulate a bad IP.
  Rails.configuration.allowed_ips = []
end

Given(/^I'm inside the firewall$/) do
  # Found "config.allowed_ips = ['127.0.0.1']" in config/application.rb.
  Rails.configuration.allowed_ips = ['127.0.0.1']
end

Then(/^I get an error message: "(.*?)"$/) do |msg|
  page.should have_content msg
end

Then(/^I should see no error$/) do
  page.should_not have_content 'Admin users may only login from approved ip addresses'
end

