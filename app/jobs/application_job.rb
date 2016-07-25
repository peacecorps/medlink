class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |error|
    Medlink.notify Notification::JobError.new klass: self.class, error: error
    raise error
  end

  def perform_later
    self.class.perform_later(*arguments)
  end
end
