require 'capybara/rails'

def login user
  visit new_user_session_path
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_on "Sign in"
end

def logout
  click_on "Sign Out"
end

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL
end
