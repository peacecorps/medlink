class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |error|
    # :nocov:
    Slackbot.new.message "#{self.class}: #{error}" if Rails.env.production?
    raise error
    # :nocov:
  end
end
