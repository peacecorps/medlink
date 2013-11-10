When(/^I create a "(.*?)" report$/) do |report_type|
  visit '/reports'
  find_link(report_type).visible?
end

When /^(?:|I )follow CSV link "([^\"]*)"$/ do |link|
  click_link(link) # If Chrome, creates the file.
  #FYI: If Firefox
  #FYI:   This opens the file dialog window.
  #FYI:   Add "cuke/file download dialog" cuke steps.
  #FYI:   "Opening <report>.csv", such as "Opening supply_history.csv"
  #FYI:     1. Check for CSV file download dialog box.
  #FYI:     2. Click on "Cancel" and it work.
end

Then(/^I got the correct "(.*?)" output$/) do |filename|
  File.exist?(ENV['HOME'] + '/Downloads' + filename + '.csv') and
  File.exist?(ENV['HOME'] + '/Downloads' + filename + '-[0-9].csv')
  #FIXME: Check the output file (# of columns, etc)
end

Then(/^I stay on reports page$/) do
  page.current_path.should == reports_path
end
