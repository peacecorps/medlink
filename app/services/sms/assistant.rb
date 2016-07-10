class SMS::Assistant < SMS::Handler
  def run! error
    key = "recent-errors:#{sms.phone_id}:last-error"
    last, times, at = stats_for key

    if last == error.class.name && at > 5.minutes.ago
      add_count key
      if times == 0
        %|Sorry, but I'm just a robot, and I don't know what you're saying. You can say "example" for an example of what I can understand, or "help" to page a human.|
      elsif times == 1
        Medlink.notify Notification::SmsHelpNeeded.new(sms: sms)
        "I still don't understand what you're saying, but I've paged a human who will get in touch with you as soon as possible."
      end
    else
      record_error key, error
      error.message
    end
  end

private

  def redis
    Medlink.redis { |r| yield r }
  end

  def stats_for key
    last, count, at = redis do |r|
      r.pipelined do
        r.get key
        r.get "#{key}-count"
        r.get "#{key}-at"
      end
    end
    [last, count.to_i, Time.at(at.to_f)]
  end

  def add_count key
    redis do |r|
      r.incr "#{key}-count"
    end
  end

  def record_error key, error
    out = 1.day.from_now.to_i
    redis do |r|
      r.pipelined do
        r.setex key,            out, error.class.name
        r.setex "#{key}-count", out, 0
        r.setex "#{key}-at",    out, Time.now.to_f
      end
    end
  end
end
