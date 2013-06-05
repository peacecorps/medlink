class BaseJob
  def self.enqueue *args
    Rails.application.config.queue.enqueue self, *args
  end
end