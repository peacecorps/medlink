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
      send_notification action: action, path: path, user: user, duration: duration
    end
    result
  end

  private

  attr_reader :timeout, :notifier

  def send_notification action:, path:, user:, duration:
    notifier.call :slow, "`#{path} => #{action}` took #{duration.round 2} for #{describe_user user}"
  end

  def describe_user user
    if user
      "#{user.name} (#{user.id} / #{user.role} in #{user.country.try :name})"
    else
      "unknown user"
    end
  end
end
