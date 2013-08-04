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

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
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
end
