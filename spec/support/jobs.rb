module JobHelpers
  def queued job_class
    ActiveJob::Base.queue_adapter.enqueued_jobs.select { |j| j[:job] == job_class }
  end
end

RSpec.configure do |config|
  config.include JobHelpers

  config.before :each, :queue_jobs do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end
end
