When(/^I create a "(.*?)" report$/) do |arg1|
  visit '/reports'
end

Then(/^I see a successful file download dialog$/) do
  #FIXME: pending "cuke/dialog"
  # "Opening <report>.csv", such as "Opening supply_history.csv"
      # 1. Check for CSV file download dialog box.
      # 2. Click on "Cancel" and it work.

  status_code.should == 200
end

Then(/^I got the correct "(.*?)" output$/) do |arg1|
  #FIXME: pending
  # 1. Check the output file (# of columns, etc)
end
