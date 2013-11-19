Given(/^I am logged in as a (\w)$/) do |role|

  email = "foo@example.com"
  passwd = "passwd"
  country = "CN"
  location = "TESHI"
  phone = "0000000000"
  first_name = "foo"
  last_name = "bar"

  # make sure the user exists
  @user = User.new(:email => email, :password => passwd, :password_confirmation => passwd, :country => country, :location => location,
                   :phone => phone, :first_name => first_name, :last_name => last_name, :role => role)

  @user.save!

  visit("users/sign_in")

  fill_in "user_email", :with => email
  fill_in "user_password", :with => passwd

  click_button "Sign in"

end

When(/^I go to the (\w) page$/) do |page|

  visit(page)

end

Then(/^I should be asked to authenticate with the right credentials$/) do
  # Ask for credential, unable to distinguish between pcmo and admin due to redirection
  err_msg 'You must be an'
end

Then(/^I should not be asked to authenticate with the right credentials$/) do
  # Shouldn't ask for credential
  no_err_msg 'You must be an'
end
