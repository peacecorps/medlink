#### UTILITY METHODS ###

def create_visitor
  email    = "joe.doe@gmail.com"
  password = "please123"
  @visitor ||= { :first_name => "Joe", :last_name => "Doe", 
    :email => email,
    :password => password, :password_confirmation => password }
end

#TODO# def find_user
#TODO#   @user ||= User.where('email' => @visitor[:email]).first
#TODO# end

#TODO# def create_unconfirmed_user
#TODO#   create_visitor
#TODO#   delete_user
#TODO#   sign_up
#TODO#   visit '/users/sign_out'
#TODO# end

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

def set_role(role)
  #ADMIN: , :role => 'admin'
  #PCV:   , :role => 'pcv'
  #PCMO:  , :role => 'pcmo'
  @user = { :role => role }
end

def sign_in
  visit '/users/sign_in'
  fill_in "email@email.com", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign in"
end

def delete_user
  @user ||= User.where('email' => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

### GIVEN ############################################################

Given /^I am not logged in$/ do
  visit '/'
end

Given /^I exist as a user$/ do
  create_user
end

Given(/^I am a "(.*?)"$/) do |role|
  set_role(role)
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

#TODO# Given /^I exist as an unconfirmed user$/ do
#TODO#   create_unconfirmed_user
#TODO# end

### WHEN #############################################################

When /^I sign in with valid credentials$/ do
  #TODO# create_visitor
  sign_in
end

When /^I sign out$/ do
  click_link "Sign Out"
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

#TODO# When /^I sign up with valid user data$/ do
#TODO#   create_visitor
#TODO#   sign_up
#TODO# end

#TODO# When /^I sign up without a password confirmation$/ do
#TODO#   create_visitor
#TODO#   @visitor = @visitor.merge(:password_confirmation => "")
#TODO#   sign_up
#TODO# end

#TODO# When /^I sign up without a password$/ do
#TODO#   create_visitor
#TODO#   @visitor = @visitor.merge(:password => "")
#TODO#   sign_up
#TODO# end

#TODO# When /^I sign up with a mismatched password confirmation$/ do
#TODO#   create_visitor
#TODO#   @visitor = @visitor.merge(:password_confirmation => "please123")
#TODO#   sign_up
#TODO# end

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

#TODO# When /^I edit my account details$/ do
#TODO#   click_link "Edit account"
#TODO#   fill_in "Name", :with => "newname"
#TODO#   fill_in "user_current_password", :with => @visitor[:password]
#TODO#   click_button "Update"
#TODO# end

#TODO# When /^I look at the list of users$/ do
#TODO#   visit '/'
#TODO# end

### THEN #############################################################

Then /^I should be signed in$/ do
  expect(current_url).to eq("http://www.example.com/orders")
end

Then /^I see a successful sign in message$/ do
  page.should have_selector ".alert", text: "Signed in successfully."
end

Then /^I should be signed out$/ do
  find("h3", :text => "Sign in").visible?
end

Then /^I should see a signed out message$/ do
  #FIXME: page.should have_content "Signed out successfully."
  page.should have_content "Invalid email or password."
end

Then /^I see an invalid login message$/ do
  page.should have_selector ".alert", text: "Invalid email or password."
end

#TODO# Then /^I see an unconfirmed account message$/ do
#TODO#   page.should have_selector ".alert", text: "You have to confirm your account before continuing."
#TODO# end

#TODO# Then /^I should see a successful sign up message$/ do
#TODO#   page.should have_content "Welcome! You have signed up successfully."
#TODO# end

#TODO# Then /^I should see an invalid email message$/ do
#TODO#   page.should have_content "Please enter an email address"
#TODO# end

#TODO# Then /^I should see a missing password message$/ do
#TODO#   page.should have_content "Password can't be blank"
#TODO# end

#TODO# Then /^I should see a missing password confirmation message$/ do
#TODO#   page.should have_content "Password doesn't match confirmation"
#TODO# end

#TODO# Then /^I should see a mismatched password message$/ do
#TODO#   page.should have_content "Password doesn't match confirmation"
#TODO# end

#TODO# Then /^I should see an account edited message$/ do
#TODO#   page.should have_content "You updated your account successfully."
#TODO# end

#TODO# Then /^I should see my name$/ do
#TODO#   create_user
#TODO#   page.should have_content @user[:name]
#TODO# end
