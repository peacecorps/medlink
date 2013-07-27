#### UTILITY METHODS ###

def create_visitor
  email    = "joe.doe@gmail.com"
  password = "please123"
  @visitor ||= { :first_name => "Joe", :last_name => "Doe", 
    :email => email,
    :password => password, :password_confirmation => password }
end

def find_user
  @user ||= User.where('email' => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/users/sign_out'
end

def create_user
  create_visitor

  delete_user

  email    = "joe.doe@gmail.com"
  password = "please123"
  @user = FactoryGirl.create(:user, 
    :email => email, :password => password, :password_confirmation => password,
    :country => FactoryGirl.create(:country), :city => "Roswell",
    :first_name => "Joe", :last_name => "Doe", :pcv_id => "12345678").save!
end

def sign_in
  visit '/users/sign_in'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign in"
end

def delete_user
  @user ||= User.where('email' => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

# 7/27/2013: SIGN_UP Functionality not supported currently.
#U# def sign_up
#U#   delete_user
#U#   visit '/users/sign_up'
#U#   fill_in "First Name", :with => @visitor[:first_name]
#U#   fill_in "Last Name", :with => @visitor[:last_name]
#U#   fill_in "Email", :with => @visitor[:email]
#U#   fill_in "PCV ID", :with => "11111111"
#U#   fill_in "Phone Number", :with => "404-532-8011"
#U#   fill_in "City", :with => "Roswell"
#U# #U# Country (menu)
#U#   fill_in "user_password", :with => @visitor[:password]
#U#   fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
#U#   click_button "Submit"
#U#   find_user
#U# end

### GIVEN ############################################################

Given /^I am not logged in$/ do
  visit '/'
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN #############################################################

When /^I sign in with valid credentials$/ do
  #U# create_visitor
  sign_in
end

When /^I sign out$/ do
  click_link "Log out"
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "please123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Edit account"
  fill_in "Name", :with => "newname"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/'
end

### THEN #############################################################

Then /^I should be signed in$/ do
  expect(current_url).to eq("http://www.example.com/orders")
  #U#page.should have_content "Logout"
  #U#page.should_not have_content "Sign up"
  #U#page.should_not have_content "Sign in"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_selector ".alert", text: "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_selector ".alert", text: "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Please enter an email address"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should be signed out$/ do
  #U# page.should have_content "You need to sign in or sign up before continuing."
end

Then /^I should see a signed out message$/ do
  puts "Signed out successfully."
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_selector ".alert", text: "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end
