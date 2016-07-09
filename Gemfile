source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.0.0'

gem 'pg'
gem 'jquery-rails'
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
gem 'sinatra', require: nil, github: 'sinatra' # 'til Sidekiq resolves the rack/showexceptions require for Rails 5

gem 'kaminari'
gem 'virtus'
gem 'reform', '2.0.5'

# TODO: need to drop draper as a dependency
gem 'draper', github: 'audionerd/draper', branch: 'rails5' # Released version breaks Rake tasks (!)
gem 'activemodel-serializers-xml' # Removed from Rails, still a dependency for draper

gem 'bullet'

gem 'bootstrap_form'
gem 's3_direct_upload'

gem 'aws-sdk'

gem 'react-rails'

gem 'dry-container'
gem 'ice_nine'

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
  gem 'letter_opener'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'coveralls', require: false
  gem 'simplecov', require: false

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
