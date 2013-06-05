class BaseJob
  def self.enqueue *args
    return self.perform(*args) if Rails.env.test?
    Resque.enqueue self, *args
  rescue Redis::CannotConnectError => e
    if Rails.env.development?
      Rails.logger.warn "Could not connect to Redis. Executing job inline."
      self.perform *args
    else
      raise
    end
  end
end