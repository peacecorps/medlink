require 'capybara/rails'

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL

  helpers = Module.new do
    include Warden::Test::Helpers
    Warden.test_mode!

    def login user
      login_as user, scope: :user, run_callbacks: false
    end

    def alert
      page.find ".flash"
    end
  end
  config.include helpers

  config.after(:each) { Warden.test_reset! }
end
