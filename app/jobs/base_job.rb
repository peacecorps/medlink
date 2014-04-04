class BaseJob
  include SuckerPunch::Job

  def self.enqueue *args
    self.new.async.perform *args
  end
end
