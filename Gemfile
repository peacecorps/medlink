source 'https://rubygems.org'

ruby '2.1.0'

gem 'rails', '4.1.0.rc1'

gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'jquery-placeholder-rails'

gem 'devise'
gem 'cancan'

gem 'sucker_punch'

gem 'business_time'

gem 'sass-rails'
gem 'coffee-rails'
gem 'haml'
gem 'uglifier'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'simplecov'
  gem 'coveralls', require: false
  gem 'table_print'
  gem 'quiet_assets'
  gem 'awesome_print'
end

gem 'rspec-rails', group: [:development, :test]
group :test do
  gem 'rake'
  gem 'factory_girl_rails'
  gem 'email_spec'
  # PR issued; please use upstream once it's merged in
  gem 'sms-spec', git: 'git@github.com:jamesdabbs/sms-spec.git'

  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'zonebie'

  gem 'show_me_the_cookies'
end

group :production do
  gem 'passenger'
  gem 'newrelic_rpm'
  gem 'pg'
  gem 'rails_12factor' # For asset compilation
end
