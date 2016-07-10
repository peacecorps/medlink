class Notifier
  class << self
    def build strategies: default_strategies
      new strategies: verify(strategies)
    end

    def load
      build strategies: default_strategies.merge(saved_strategies)
    end

    def save_strategies! strats
      symbolized = symbolize strats
      verify symbolized

      Medlink.redis do |r|
        r.hmset "notifier.strategies", *symbolized.to_a.flatten
      end
    end

    def reset!
      save_strategies! default_strategies
    end

    def default_strategies
      {
        sending_country_sms:           :slack,
        user_activated:                :slack,
        invalid_response_receipt:      :slack,
        reprocessing_response_receipt: :slack,
        sms_help_needed:               :slack,
        invalid_roster_upload_row:     :ping,
        announcement_scheduled:        :ping,
        job_error:                     :ping,
        flag_for_followup:             :ping,
        slow:                          :ping,
        spam_warning:                  :ping,
        unrecognized_sms:              :ping,
        updated_user:                  :ping,
        new_report_ready:              :ping,
        sending_response:              :log,
        prompt_for_acknowledgement:    :log,
        delivery_failure:              :log
      }
    end

    def all
      Dir["#{Rails.root.join 'app', 'models', 'notification'}/*"].each { |n| require n } unless Rails.env.production?
      Notification::Base.subclasses
    end

    private

    def saved_strategies
      found = Medlink.redis do |r|
        r.hgetall "notifier.strategies"
      end
      symbolize found
    end

    def verify strategies
      # FIXME: we should just store the key => key hash, as auto-reloading mucks with
      # matching based on class
      hydrated = all.each_with_object({}) do |klass, h|
        h[klass.key] = Notifier::Strategy.find(strategies[klass.key]).try(:key)
      end

      missing = hydrated.select { |k,v| v.nil? }.keys
      if missing.any?
        raise Notifier::Strategy::Missing, "No strategy defined for #{missing.to_sentence}"
      end

      hydrated
    end

    def symbolize h
      h.map { |k,v| [k.to_sym, v.to_sym] }.to_h
    end
  end

  def call notification
    if strategy = Notifier::Strategy.find(@strategies[notification.class.key])
      strategy.call notification
    else
      unhandled notification
    end
  end

  def allowed_strategies
    Notifier::Strategy.all
  end

  def strategies
    Notifier.all.each_with_object({}) do |strat, h|
      h[strat] = @strategies[strat.key]
    end
  end

private

  def initialize strategies: nil
    @strategies = strategies
    deep_freeze
  end

  def unhandled msg
    error = "Unhandled `#{msg.class}` - '#{msg.text}'"
    Rails.env.production? ? ping(error) : raise(Strategy::Missing, error)
  end
end
