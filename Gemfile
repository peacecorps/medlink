source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails'

gem 'pg'
gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'jquery-placeholder-rails'
gem 'pry-rails'

gem 'figaro'
gem 'devise'
gem 'pundit'

gem 'rollbar'
gem 'sidekiq'
gem 'sinatra', require: nil

gem 'kaminari'
gem 'virtus'
gem 'draper'

gem 'nested_form'

gem 'quiet_assets'

gem 'bullet'

gem 'bootstrap_form'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'letter_opener'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'coveralls', require: false
  gem 'simplecov'

  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-given'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'zonebie'
  gem 'timecop'
end

gem 'newrelic_rpm'
group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'skylight'
end
