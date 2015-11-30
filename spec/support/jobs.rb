module JobHelpers
  def queued job_class
    ActiveJob::Base.queue_adapter.enqueued_jobs.select { |j| j[:job] == job_class }
  end
end

RSpec.configure do |config|
  config.include JobHelpers

  config.around :each, :queue_jobs do |x|
    _old = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    x.run
    ActiveJob::Base.queue_adapter = _old
  end
end
