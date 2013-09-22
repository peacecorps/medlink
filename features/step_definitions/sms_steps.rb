When(/^I send a sms request$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I give it all the valid sms inputs$/) do
  #FORMAT:  "PCVID, Supply short name, ,dose, qty, location."
  pending # express the regexp above with the code you wish you had
end

When(/^I give it all sms inputs but "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

#P5
Then(/^I see a successful sms request message$/) do
  page.should have_selector ".alert", text: "Your request has been " +
    "received. Fulfillment details will follow within 3 business " +
    "days. Please refrain from multiple requests."
end

#F
Then(/^I see a bad PCVID sms request message$/) do
  onev = twov = "PCVID"
  page.should have_selector ".alert", text: "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#G
Then(/^I see a invalid supply sms request message$/) do
  onev = "Supply short name"
  twov = "supply name"
  page.should have_selector ".alert", text: "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#H
Then(/^I see a invalid dose sms request message$/) do
  onev = "Dose"
  twov = "dose"
  page.should have_selector ".alert", text: "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#I
Then(/^I see a invalid Qty sms request message$/) do
  onev = "Qty"
  twov = "quantity"
  page.should have_selector ".alert", text: "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#I
Then(/^I see a nonnumber Qty sms request message$/) do
  onev = "Qty"
  twov = "quantity"
  page.should have_selector ".alert", text: "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

#J
Then(/^I see a invalid Location sms request message$/) do
  onev = "Location"
  twov = "location"
  page.should have_selector ".alert", text: "#{onev} invalid: " +
    "Your request was not submitted because #{twov} was incorrect. " +
    "Please resubmit the request in this format: " +
    "PCVID, Supply short name, ,dose, qty, location."
end

