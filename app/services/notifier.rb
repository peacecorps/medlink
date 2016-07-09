class Notifier
  class Strategy
    Missing = Class.new StandardError

    def initialize key:, label:, &block
      @key, @label = key, label
      @deliverer   = block
      deep_freeze
    end

    attr_reader :key, :label

    def call msg
      @deliverer.call msg
    end

    def inspect
      # :nocov:
      %|<#{self.class.name}("#{label}")>|
      # :nocov:
    end
  end

  Slack = Strategy.new key: :slack, label: "Public Slack channel" do |msg|
    Medlink.slackbot.call msg.slack
  end

  Ping = Strategy.new key: :ping, label: "Private Slack channel" do |msg|
    Medlink.pingbot.call msg.slack
  end

  Log = Strategy.new key: :log, label: "Server logs" do |msg|
    Rails.logger.info msg.text
  end


  Strategies = [Slack, Ping, Log]


  class << self
    def build strategies: default_strategies
      new strategies: hydrate_and_verify(strategies)
    end

    def load
      build strategies: default_strategies.merge(saved_strategies)
    end

    def save_strategies! strats
      symbolized = symbolize strats
      hydrate_and_verify symbolized

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

    private

    def all
      Dir["#{Rails.root.join 'app', 'models', 'notification'}/*"].each { |n| require n }
      Notification::Base.subclasses
    end

    def saved_strategies
      found = Medlink.redis do |r|
        r.hgetall "notifier.strategies"
      end
      symbolize found
    end

    def hydrate_and_verify strategies
      hydrated = all.each_with_object({}) do |klass, h|
        h[klass] = Strategies.find { |s| s.key == strategies[klass.key] }
      end

      missing = hydrated.select { |k,v| v.nil? }.keys
      if missing.any?
        raise Strategy::Missing, "No strategy defined for #{missing.to_sentence}"
      end

      hydrated
    end

    def symbolize h
      h.map { |k,v| [k.to_sym, v.to_sym] }.to_h
    end
  end

  def call notification
    if strategy = strategies[notification.class]
      strategy.call notification
    else
      unhandled notification
    end
  end

  attr_reader :strategies

  def allowed_strategies
    [Slack, Ping, Log]
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
