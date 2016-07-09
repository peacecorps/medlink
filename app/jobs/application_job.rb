class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |error|
    Medlink.notify Notification::JobError.new klass: self.class, error: error
    raise error
  end
end
