#### UTILITY METHODS ###

def create_visitor
  email    = "joe.doe@gmail.com"
  password = "please123"
  @visitor ||= { :first_name => "Joe", :last_name => "Doe", 
    :email => email,
    :password => password, :password_confirmation => password }
end

def create_user role: :user, name: "joe"
  email    = "#{name}.doe@gmail.com"
  password = "please123"
  pcv_id = Random.new.rand(10000000..99999999).to_s
  @user = FactoryGirl.create(role.to_sym, 
    :email => email, :password => password, :password_confirmation => password,
    :country => FactoryGirl.create(:country), :city => "Roswell",
    :first_name => name, :last_name => "Doe", :pcv_id => pcv_id)
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

Given /^the default user exists$/ do
  create_visitor
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

Given /^I am logged in as (a|an|the) (\w+)$/ do |_, role|
   create_user role: role
   create_visitor
   sign_in
end

When /^I sign in with valid credentials$/ do
  create_visitor
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

Given(/^that pcv "(.*?)" exists$/) do |name|
  create_user role: :user, name: name
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
