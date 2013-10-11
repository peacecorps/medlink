When(/^I create a "(.*?)" report$/) do |arg1|
  visit '/reports'
end

Then(/^I see a successful file download dialog$/) do
  #FIXME: Add "cuke/file download dialog" cuke steps.
  #FIXME: "Opening <report>.csv", such as "Opening supply_history.csv"
  #FIXME:    1. Check for CSV file download dialog box.
  #FIXME:    2. Click on "Cancel" and it work.

  status_code.should == 200
end

Then(/^I got the correct "(.*?)" output$/) do |arg1|
  #FIXME: Check the output file (# of columns, etc)
  visit '/reports'
end

Then(/^I stay on reports page$/) do
  expect(current_url).to eq("http://www.example.com/reports")
end
