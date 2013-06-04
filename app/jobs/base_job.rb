class BaseJob
  def self.enqueue *args
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