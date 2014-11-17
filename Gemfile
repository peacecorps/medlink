source 'https://rubygems.org'

ruby '2.1.4'

gem 'rails', '4.1.1'

gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'jquery-placeholder-rails'

gem 'devise'
gem 'cancan'

gem 'sucker_punch'

gem 'kaminari'

gem 'nested_form'

group :assets do
  # 2.12.0 is borked - https://github.com/sstephenson/sprockets/issues/537
  gem 'sprockets', '2.11.0'
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
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'sms-spec'
  gem 'database_cleaner'
  gem 'zonebie'
end

group :production do
  gem 'exceptiontrap'
  gem 'unicorn'
  gem 'pg'
  gem 'rails_12factor' # For asset compilation
end
