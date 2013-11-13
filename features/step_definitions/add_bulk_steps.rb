When(/^I upload a csv file "(.*?)" with (.*?) valid data$/) do |filename, some_all|
  $USER_COUNT = User.count # ; puts "BEFORE COUNT=[" + $USER_COUNT.to_s + "]"
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', filename))
  click_button "Upload CSV"
end

When(/^I upload a csv file with some good and some bad user data$/) do
  $USER_COUNT = User.count # ; puts "BEFORE COUNT=[" + $USER_COUNT.to_s + "]"
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'users_csv_some_bad.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with all bad user data$/) do
  $USER_COUNT = User.count # ; puts "BEFORE COUNT=[" + $USER_COUNT.to_s + "]"
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'users_csv_all_bad.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with empty file$/) do
  $USER_COUNT = User.count # ; puts "BEFORE COUNT=[" + $USER_COUNT.to_s + "]"
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'empty.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with missing header$/) do
  $USER_COUNT = User.count # ; puts "BEFORE COUNT=[" + $USER_COUNT.to_s + "]"
  attach_file(:csv, File.join(Rails.root, 'features',
    'upload-files', 'missing1stLine.csv'))
  click_button "Upload CSV"
end

When(/^I check on "(.*?)"$/) do |chkbox|
  check(chkbox)
end

When(/^I uncheck on "(.*?)"$/) do |chkbox|
  uncheck(chkbox)
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
  File.exist?('/tmp/invalid_users.csv') and File.exist?('/tmp/invalid_users-[0-9].csv')
end

Then(/^I should not download anything invalid$/) do
  !File.exist?('/tmp/invalid_users.csv') or !File.exist?('/tmp/invalid_users-[0-9].csv')
end

Then(/^the number of users should change to (\d+)$/) do |count|
  User.count.should == count.to_i
  # puts "BEFORE_COUNT=[" + $USER_COUNT.to_s + "]"
  # puts "AFTER_COUNT=[" + User.count.to_s + "]"
end

Then(/^the number of users should not change$/) do
  $USER_COUNT.should == User.count.to_i # NOT CHANGE
  # pending # FIXME: Implement "number of users should not change"
end
#save_and_open_page
