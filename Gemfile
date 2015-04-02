source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails', '4.2.1'

gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'jquery-placeholder-rails'

gem 'devise'
gem 'cancan'

gem 'sucker_punch'
gem 'rollbar'

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
  gem 'pry'
  gem 'quiet_assets'
  gem 'sqlite3'

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
  gem 'pg'
  gem 'puma'
  gem 'rails_12factor'
end
