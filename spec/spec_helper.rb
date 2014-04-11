ENV["RAILS_ENV"] ||= 'test'

# Run specs under COVERAGE=true to generate coverage reports
if ENV["COVERAGE"]
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start 'rails' do
    add_group "Jobs", "app/jobs"

    add_filter ".bundle"
  end
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Pry is useful locally but we don't want to require to for e.g. Travis
begin
  require 'pry'
rescue LoadError
end

# Runs all background jobs in-band
require 'sucker_punch/testing/inline'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

SmsSpec.driver = :"twilio-ruby"
%w(ACCOUNT_SID AUTH PHONE_NUMBER).each do |k|
  ENV["TWILIO_#{k}"] ||= "xxxxxx"
end

# SmsSpec stubs out Twilio methods, but we still fetch these from the env, so
# they at least need to be present

RSpec.configure do |config|
  config.mock_with :rspec

  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  # Allow focusing on specs
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Allow tweaking of failure mode
  config.fail_fast = false

  # Since background jobs run in a separate thread, we can't use the
  # default transactions. These settings should allow you to specify
  # :worker specs which rely on data persisting into the background
  # job.
  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end
  config.before :each, worker: true do
    DatabaseCleaner.strategy = :truncation
  end
  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end

  Zonebie.set_random_timezone
end
