When(/^I upload a csv file with all valid data for (\d+) new users$/) do |count|
  pending "Debug FIXME below"
  #FIXME: attach_file(:csv_file, File.join(RAILS_ROOT, 'features', 'upload-files', 'users_csv_ok.csv'))
  click_button "Upload CSV"
end

When(/^I upload a csv file with some good and some bad user data$/) do
  pending "Debug FIXME below"
  #FIXME: attach_file(:csv_file, File.join(RAILS_ROOT, 'features', 'upload-files', 'users_csv_bad.csv'))
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
