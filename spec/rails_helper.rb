# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start 'rails' do
    add_group "Forms",      "app/forms"
    add_group "Jobs",       "app/jobs"
    add_group "Policies",   "app/policies"
    add_group "Presenters", "app/presenters"
    add_group "Services",   "app/services"

    add_filter "/lib/slackbot"
  end
end

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'capybara/poltergeist'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist

Medlink::Application.eager_load! if ENV["COVERAGE"]


RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  def clean!
    # TODO:
    # * for some reason, `only` seems to work here, but `except` is being ignored
    to_clean = ActiveRecord::Base.connection.tables - %w( schema_migrations countries supplies country_supplies twilio_accounts )
    DatabaseCleaner.clean_with :truncation, only: to_clean
  end

  def same_time t1, t2
    # DB round-trips may lose some precision; ignore that
    t1.to_f.round(3) == t2.to_f.round(3)
  end

  def p
    # Pry inside a Given-When chain, and don't re-run the assertion
    Then { binding.pry; true }
  end

  config.before :suite do
    clean!
    NamedSeeds.load_seed unless Country.any?

    # TODO: pre-load an admin, and a pcmo and pcv(?) per-country
  end
end
