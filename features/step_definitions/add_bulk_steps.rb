When(/^I upload a csv file with all valid data for (\d+) new users$/) do |count|
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'users_csv_all_good.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with some good and some bad user data$/) do
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'users_csv_some_bad.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with all bad user data$/) do
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'users_csv_all_bad.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with empty file$/) do
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'empty.csv'))
end

When(/^I upload a csv file with missing header$/) do
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'missing1stLine.csv'))
end

Then(/^I should see browse button "(.*?)"$/) do |name|
  find_field(name).visible?
end

Then(/^I should go back to the add user upload page$/) do
  page.current_path.should == admin_users_uploadCSV_path
end

Then(/^I should sent to the add user page$/) do
  page.current_path.should == new_admin_user_path
end

Then(/^I should download an error file with bad data and error messages$/) do
#FIXME: Problem with suffix if filename is already there.
  File.exist?('/tmp/invalid_users.csv') and File.exist?('/tmp/invalid_users-[0-9].csv')
end

Then(/^I should not download anything$/) do
  !File.exist?('/tmp/invalid_users.csv') or !File.exist?('/tmp/invalid_users-[0-9].csv')
end

Then(/^the number of users should change to (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the number of users should not change$/) do
  pending # express the regexp above with the code you wish you had
end
