class Notifier
  class Strategy
    Missing = Class.new StandardError

    class << self
      def build key, label, &block
        new key: key, label: label, deliverer: block
      end

      def all
        ::Notifier::Strategies
      end

      def find key
        key = key && key.to_sym
        all.find { |klass| klass.key == key }
      end

      def fetch key
        return key if key.is_a? Strategy
        find(key) || raise(Missing.new key)
      end
    end

    def initialize key:, label:, deliverer:
      @key, @label, @deliverer = key, label, deliverer
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

    Slack = build :slack, "Public Slack channel" do |msg|
      Medlink.slackbot.call msg.slack
    end

    Ping = build :ping, "Private Slack channel" do |msg|
      Medlink.pingbot.call msg.slack
    end

    Log = build :log, "Server logs" do |msg|
      Rails.logger.info msg.text
    end

    Telegram = build :telegram, label: "Telegram message" do |msg|
      Medlink.telegram.call msg.user, msg.telegram
    end

    Text = build :sms, "Send SMS" do |msg|
      msg.sms.perform_later
    end

    Email = build :email, "Send Email" do |msg|
      msg.email.deliver_later
    end

    ::Notifier::Strategies = [Slack, Ping, Log, Telegram, Text, Email]
  end
end
