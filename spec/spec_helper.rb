ENV["RAILS_ENV"] ||= 'test'

# This has to be required before booting the Rails environment
require_relative "../spec/support/coverage"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = "random"
end
