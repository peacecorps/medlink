#### UTILITY METHODS ###

def create_visitor
  email    = "joe.doe@gmail.com"
  password = "please123"
  @visitor ||= { :first_name => "Joe", :last_name => "Doe", 
    :email => email,
    :password => password, :password_confirmation => password }
end

def create_user role: :user, name: "joe", country: nil
  email    = "#{name}.doe@gmail.com"
  password = "please123"
  pcv_id = Random.new.rand(10000000..99999999).to_s
  user_country = country || FactoryGirl.create(:country)
  @user = FactoryGirl.create(role.to_sym, 
    :email => email, :password => password, :password_confirmation => password,
    :country => user_country, :city => "Roswell",
    :first_name => name, :last_name => "Doe", :pcv_id => pcv_id)
end

def set_role(role)
  #ADMIN: , :role => 'admin'
  #PCV:   , :role => 'pcv'
  #PCMO:  , :role => 'pcmo'
  #WAS: @user = { :role => role }
  if @user
    @user.update_attributes(role: role)
    @user.save
  else
    @user = User.new(role: role)
  end
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

Given(/^I am (a|an|the) "(.*?)"$/) do |_, role|
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

Given(/^I am logged in as (a|an|the) (\w+) of (\w+)$/) do |_, role, country|
   create_user role: role, country: Country.find_by_name(country)
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

Then (/^I should be signed in as "(.*?)"$/) do |role|
  if role == "admin"
    expect(current_url).to eq("http://www.example.com/admin/users/new")
  elsif role == "pcmo"
    expect(current_url).to eq("http://www.example.com/orders/manage")
  else
    expect(current_url).to eq("http://www.example.com/orders")
  end
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

Given(/^that the following pcvs exist:$/) do |users|
  users.hashes.each do |user|
    FactoryGirl.create :user, first_name: user['name'], pcv_id: user['pcv_id'], country: Country.find_by_name(user['country'])
  end
end

When(/^I give valid password inputs$/) do
  visit '/users/edit'
  fill_in "Current Password", :with => @visitor[:password]
  fill_in "New Password", :with => @visitor[:password] + "1"
  fill_in "Password Confirmation", :with => @visitor[:password] + "1"
  click_button "Update"
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

When(/^I give invalid password$/) do
  visit '/users/edit'
  fill_in "Current Password", :with => "WRONG PW"
  fill_in "New Password", :with => @visitor[:password] + "1"
  fill_in "Password Confirmation", :with => @visitor[:password] + "1"
  click_button "Update"
end

Then(/^I should see an invalid current password message$/) do
  page.should have_content "Current password is invalid"
end

When(/^I give blank password$/) do
  visit '/users/edit'
  fill_in "Current Password", :with => "WRONG PW"
  fill_in "New Password", :with => ''
  fill_in "Password Confirmation", :with => ''
  click_button "Update"
end

Then(/^I should see an blank current password message$/) do
  page.should have_content "Current password is invalid"
end

When(/^I give mismatched passwords$/) do
  visit '/users/edit'
  fill_in "Current Password", :with => @visitor[:password]
  fill_in "New Password", :with => @visitor[:password] + "1"
  fill_in "Password Confirmation", :with => @visitor[:password] + "2"
  click_button "Update"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password confirmation doesn't match Password"
end

When(/^I give too short new password$/) do
  visit '/users/edit'
  fill_in "Current Password", :with => @visitor[:password]
  fill_in "New Password", :with => "2short"
  fill_in "Password Confirmation", :with => "2short"
  click_button "Update"
end

Then(/^I should see a too short password message$/) do
  page.should have_content "Password is too short (minimum is 8 characters)"
end


