class BaseJob
  def self.enqueue *args
    self.new.async.perform *args
  end
end
