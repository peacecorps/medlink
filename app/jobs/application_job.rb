class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |error|
    # :nocov:
    Notification.send :error_in_job, "#{self.class}: #{error}" if Rails.env.production?
    raise error
    # :nocov:
  end
end
