# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'capybara/poltergeist'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
end

Medlink::Application.eager_load! if ENV["COVERAGE"]

module ApiHelpers
  def authorized user, &block
    resp = block.call
    if resp.status == 401
      ApiAuth.sign! @request, user.id, user.secret_key
      block.call
    else
      resp
    end
  end

  def json
    @_json ||= JSON.parse(response.body)
  end
end

module FeatureHelpers
  def screenshot path=nil
    path ||= "#{ENV['HOME']}/Desktop/screenshot.png"
    page.save_screenshot path, full: true
  end

  def login_as user
    page.driver.browser.clear_cookies
    visit root_path
    within ".sign-in" do
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_on "Sign In"
    end
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  def clean!
    # TODO:
    # * for some reason, `only` seems to work here, but `except` is being ignored
    to_clean = ActiveRecord::Base.connection.tables - %w( schema_migrations countries supplies country_supplies twilio_accounts )
    DatabaseCleaner.clean_with :truncation, only: to_clean
  end

  def queued job_class
    ActiveJob::Base.queue_adapter.enqueued_jobs.select { |j| j[:job] == job_class }
  end

  def slackbot
    Rails.configuration.slackbot
  end

  def pingbot
    Rails.configuration.pingbot
  end

  def mail
    ActionMailer::Base.deliveries
  end

  config.before :suite do
    clean!
    NamedSeeds.load_seed unless Country.any?

    # TODO:
    # * figure out why some test runs don't clean up after themselves
    # DatabaseCleaner.clean_with :truncation, except: %w( countries supplies country_supplies twilio_account )
  end

  config.before :each do
    ActionMailer::Base.deliveries = []
  end

  # TODO: many of these tests don't really need to hit Twilio and should probably opt out
  config.around :each, :vcr do |x|
    name = x.full_description.gsub /\W+/, '-'
    VCR.use_cassette name, re_record_interval: 1.week do
      x.run
    end
  end

  config.around(:each) do |x|
    if x.metadata[:js]
      x.run
      clean!
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
      x.run
      DatabaseCleaner.clean
    end
  end

  config.around :each, :queue_jobs do |x|
    _old = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    x.run
    ActiveJob::Base.queue_adapter = _old
  end

  config.around :each, bullet: false do |x|
    Bullet.enable = false
    x.run
    Bullet.enable = true
  end

  config.include ApiHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
end
