source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'

gem 'devise'

gem 'resque'

gem 'font-awesome-rails'
gem 'angularjs-rails-resource'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'haml'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'binding_of_caller'
end

group :production do
  gem 'pg'  # Only needed for Heroku deployment
end
