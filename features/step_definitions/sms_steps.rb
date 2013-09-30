# -------------------------------------------
# Available methods
# -------------------------------------------

# messages
# add_message
# set_current_number
# current_number
# clear_messages
# current_text_message
# open_last_text_message_for

Given /^no text messages have been sent$/ do
  clear_messages
end

Given /^all text messages have been read$/ do
  clear_messages
end

When /^"([^\"]*?)" opens? the text message$/ do |mobile_number|
  open_last_text_message_for(mobile_number)
end

Then /^"([^\"]*)" should receive a text message$/ do |phone_number|
  messages_for(phone_number).should_not be_empty
end

Then /^"([^\"]*)" should receive no text messages$/ do |phone_number|
  messages_for(phone_number).should be_empty
end

Then /^I should see "([^\"]*)" in the text message body$/ do |content|
  current_text_message.should have_body(content)
end

Then /^I should see the following in the text message body:$/ do |content|
  current_text_message.should have_body(content)
end

######################################################################
#CUSTOM STEPS

When(/^I give it all the valid sms inputs$/) do
  set_current_number "+5555555512"

  msg = '123456, ASDF, 30mg, 50, Somewhere'
puts msg  
  #FORMAT:  "PCVID, Supply short name, ,dose, qty, location."
  # FIXME: add_message Message.new :number => "5555555512", :body => msg
end

When(/^I give it all sms inputs but "(.*?)"$/) do |field|
  set_current_number "+5555555512"

  pcvid = "123456"
  shortcode = "ASDF"
  dosage = "30mg"
  qty = "50"
  loc = "Somewhere"
  case field
    when 'pcvid'
      pcvid = ''
    when 'shortcode'
      shortcode = ''
    when 'dosage'
      dosage = ''
    when 'qty'
      qty = ''
    when 'loc'
      loc = ''
  end
  msg = pcvid + ", " + shortcode + ", " + dosage + ", " + qty + ", " + loc
puts msg

  #FORMAT:  "PCVID, Supply short name, ,dose, qty, location."
  # FIXME: add_message Message.new :number => "5555555512", :body => msg
end

When(/^I send a sms request$/) do
#FIXME  pending # express the regexp above with the code you wish you had
end

#P5
Then(/^I see a successful sms request message$/) do
  current_text_message.should have_body "Your request has been " +
    "received. Fulfillment details will follow within 3 business " +
    "days. Please refrain from multiple requests."
end

#F
Then(/^I see a bad PCVID sms request message$/) do
  onev = twov = "PCVID"
  current_text_message.should have_body "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#G
Then(/^I see a invalid supply sms request message$/) do
  onev = "Supply short name"
  twov = "supply name"
  current_text_message.should have_body "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#H
Then(/^I see a invalid dose sms request message$/) do
  onev = "Dose"
  twov = "dose"
  current_text_message.should have_body "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#I
Then(/^I see a invalid Qty sms request message$/) do
  onev = "Qty"
  twov = "quantity"
  current_text_message.should have_body "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#I
Then(/^I see a nonnumber Qty sms request message$/) do
  onev = "Qty"
  twov = "quantity"
  current_text_message.should have_body "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#J
Then(/^I see a invalid Location sms request message$/) do
  onev = "Location"
  twov = "location"
  current_text_message.should have_body "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

