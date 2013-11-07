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

Then(/^I should see browse button "(.*?)"$/) do |name|
  find_field(name).visible?
end

Then(/^I should go back to the add user page$/) do
  assert page.current_path == new_admin_user_path
end

Then(/^I should be sent to the add user page$/) do
  assert page.current_path == new_admin_user_path
end

Then(/^I should download a invalid_users\.csv with bad data and error messages$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not download anything$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the number of users should change to (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the number of users should not change$/) do
  pending # express the regexp above with the code you wish you had
end
