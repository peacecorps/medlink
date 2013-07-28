#### UTILITY METHODS ###

def create_visitor
  email    = "joe.doe@gmail.com"
  password = "please123"
  @visitor ||= { :first_name => "Joe", :last_name => "Doe", 
    :email => email,
    :password => password, :password_confirmation => password }
end

#U# def find_user
#U#   @user ||= User.where('email' => @visitor[:email]).first
#U# end

#U# def create_unconfirmed_user
#U#   create_visitor
#U#   delete_user
#U#   sign_up
#U#   visit '/users/sign_out'
#U# end

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

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

#U# Given /^I am logged in$/ do
#U#   create_user
#U#   sign_in
#U# end

#U# Given /^I exist as an unconfirmed user$/ do
#U#   create_unconfirmed_user
#U# end

### WHEN #############################################################

When /^I sign in with valid credentials$/ do
  #U# create_visitor
  sign_in
end

#U# When /^I sign out$/ do
#U#   click_link "Log out"
#U# end

#U# When /^I sign up with valid user data$/ do
#U#   create_visitor
#U#   sign_up
#U# end

#U# When /^I sign up with an invalid email$/ do
#U#   create_visitor
#U#   @visitor = @visitor.merge(:email => "notanemail")
#U#   sign_up
#U# end

#U# When /^I sign up without a password confirmation$/ do
#U#   create_visitor
#U#   @visitor = @visitor.merge(:password_confirmation => "")
#U#   sign_up
#U# end

#U# When /^I sign up without a password$/ do
#U#   create_visitor
#U#   @visitor = @visitor.merge(:password => "")
#U#   sign_up
#U# end

#U# When /^I sign up with a mismatched password confirmation$/ do
#U#   create_visitor
#U#   @visitor = @visitor.merge(:password_confirmation => "please123")
#U#   sign_up
#U# end

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

#U# When /^I edit my account details$/ do
#U#   click_link "Edit account"
#U#   fill_in "Name", :with => "newname"
#U#   fill_in "user_current_password", :with => @visitor[:password]
#U#   click_button "Update"
#U# end

#U# When /^I look at the list of users$/ do
#U#   visit '/'
#U# end

### THEN #############################################################

Then /^I should be signed in$/ do
  expect(current_url).to eq("http://www.example.com/orders")
end

#U# Then /^I see an unconfirmed account message$/ do
#U#   page.should have_selector ".alert", text: "You have to confirm your account before continuing."
#U# end

Then /^I see a successful sign in message$/ do
  page.should have_selector ".alert", text: "Signed in successfully."
end

#U# Then /^I should see a successful sign up message$/ do
#U#   page.should have_content "Welcome! You have signed up successfully."
#U# end

#U# Then /^I should see an invalid email message$/ do
#U#   page.should have_content "Please enter an email address"
#U# end

#U# Then /^I should see a missing password message$/ do
#U#   page.should have_content "Password can't be blank"
#U# end

#U# Then /^I should see a missing password confirmation message$/ do
#U#   page.should have_content "Password doesn't match confirmation"
#U# end

#U# Then /^I should see a mismatched password message$/ do
#U#   page.should have_content "Password doesn't match confirmation"
#U# end

Then /^I should be signed out$/ do
  #U# page.should have_content "You need to sign in or sign up before continuing."
end

#U# Then /^I should see a signed out message$/ do
#U#   puts "Signed out successfully."
#U#   page.should have_content "Signed out successfully."
#U# end

Then /^I see an invalid login message$/ do
  page.should have_selector ".alert", text: "Invalid email or password."
end

#U# Then /^I should see an account edited message$/ do
#U#   page.should have_content "You updated your account successfully."
#U# end

#U# Then /^I should see my name$/ do
#U#   create_user
#U#   page.should have_content @user[:name]
#U# end
