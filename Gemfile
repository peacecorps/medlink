source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails', '4.2.1'

gem 'pg'
gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'jquery-placeholder-rails'

gem 'devise'
gem 'cancan'

gem 'rollbar'
gem 'sidekiq'
gem 'sinatra', require: nil

gem 'kaminari'

gem 'nested_form'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'bullet'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'quiet_assets'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'coveralls', require: false
  gem 'simplecov'

  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'sms-spec'
  gem 'database_cleaner'
  gem 'zonebie'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
end
