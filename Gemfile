source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.14.rc2'
gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'

gem 'devise'

gem 'unicorn'
#U# gem 'unicorn-rails'
gem 'sucker_punch'

gem 'font-awesome-rails'
gem 'angularjs-rails-resource'

group :assets do
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'coffee-rails'
  gem 'haml'
  gem 'uglifier'
end

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'letter_opener'
  gem 'simplecov'
  gem 'coveralls', require: false
end

gem 'rspec-rails', group: [:development, :test]
group :test do
  gem 'rake'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'sms-spec'

  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
end

group :production do
  gem 'newrelic_rpm'
  gem 'pg'
end
