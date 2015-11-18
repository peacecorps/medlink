class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |error|
    # :nocov:
    Rails.configuration.slackbot.error "#{self.class}: #{error}" if Rails.env.production?
    raise error
    # :nocov:
  end
end
