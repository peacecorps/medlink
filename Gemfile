source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails'

gem 'pg'
gem 'jquery-rails'
# FIXME: remove
gem 'haml-rails'
gem 'slim-rails'
gem 'jbuilder'
gem 'twilio-ruby'
gem 'pry-rails'

gem 'figaro'
gem 'devise'
gem 'pundit'
gem 'api-auth'

gem 'rollbar'
gem 'sidekiq'
gem 'sinatra', require: nil

gem 'kaminari'
gem 'virtus'
gem 'draper'
gem 'reform'

gem 'quiet_assets'

gem 'bullet'

gem 'bootstrap_form'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'activerecord-import'
  gem 'named_seeds'
  gem 'pry-byebug'
  gem 'letter_opener'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'coveralls', require: false
  gem 'simplecov'

  gem 'rspec-rails'
  gem 'rspec-given'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
  gem 'zonebie'
  gem 'timecop'
  gem 'poltergeist'
end

gem 'newrelic_rpm'
group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'skylight'
end
