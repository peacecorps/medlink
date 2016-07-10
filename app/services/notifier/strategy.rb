class Notifier
  class Strategy
    Missing = Class.new StandardError

    class << self
      def all
        [Slack, Ping, Log]
      end

      def find key
        key = key && key.to_sym
        all.find { |klass| klass.key == key }
      end
    end

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

    Slack = new key: :slack, label: "Public Slack channel" do |msg|
      Medlink.slackbot.call msg.slack
    end

    Ping = new key: :ping, label: "Private Slack channel" do |msg|
      Medlink.pingbot.call msg.slack
    end

    Log = new key: :log, label: "Server logs" do |msg|
      Rails.logger.info msg.text
    end
  end
end
