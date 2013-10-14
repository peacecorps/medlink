When(/^I create a "(.*?)" report$/) do |report_type|
  visit '/reports'
  find_link(report_type).visible?
end

Then(/^I stay on reports page$/) do
  expect(current_url.split('/')[3]).to eq("reports")
end

When /^(?:|I )follow CSV link "([^\"]*)"$/ do |link|
  click_link(link) # This opens the file dialog window.
  #FIXME: Add "cuke/file download dialog" cuke steps.
  #FIXME: "Opening <report>.csv", such as "Opening supply_history.csv"
  #FIXME:    1. Check for CSV file download dialog box.
  #FIXME:    2. Click on "Cancel" and it work.
end

Then(/^I got the correct "(.*?)" output$/) do |arg1|
  #FIXME: Check the output file (# of columns, etc)
  visit '/reports'
end
