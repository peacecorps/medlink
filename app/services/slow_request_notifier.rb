class SlowRequestNotifier
  def self.build timeout: nil, notifier:
    new \
      timeout:  timeout || ENV.fetch("SLOW_TIMEOUT", 1).to_f.seconds,
      notifier: notifier
  end

  def initialize timeout:, notifier:
    @timeout, @notifier = timeout, notifier
  end

  def call action:, path:, user:, &block
    start = Time.now
    result = block.call
    duration = Time.now - start
    if duration > timeout
      notifier.call Notification::SlowRequest.new \
        action: action, path: path, user: user, duration: duration
    end
    result
  end

  private

  attr_reader :timeout, :notifier
end
