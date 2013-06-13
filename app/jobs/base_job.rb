class BaseJob
  include SuckerPunch::Worker

  def self.queue
    name.underscore.to_sym
  end

  def self.enqueue *args
    SuckerPunch::Queue.new(self.queue).async.perform *args
  end
end
