require 'capybara/rails'

def login user
  visit "/users/sign_in"
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_on "Sign in"
end

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL
end
