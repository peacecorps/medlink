class Notifier
  NotFound = Class.new StandardError

  attr_reader :preferences

  class << self
    def build
      new preferences: Notifier::Preferences::System.new
    end

    def notifications
      @_notifications ||= begin
        force_load!
        Notification::Base.subclasses
      end
    end

    def fetch key
      notifications.find { |klass| klass.key == key } || raise(NotFound.new key)
    end

    def strategies
      Notifier::Strategy.all
    end

    def force_load!
      return if Rails.env.production?
      Dir["#{Rails.root.join 'app', 'models', 'notification'}/*"].each { |n| require n }
    end
  end

  def call notification
    strategies = strategies_for notification: notification
    if strategies.present?
      strategies.each { |s| s.call notification }
    else
      unhandled notification
    end
  end

  def reset!
    preferences.reset!
  end

private

  def strategies_for notification:
    prefs = notification.for_user? ? Notifier::Preferences::User.new(notification.user) : preferences
    prefs.for notification.class
  end

  def initialize preferences: nil
    @preferences = preferences
    freeze
  end

  def unhandled msg
    error = "Unhandled `#{msg.class}` - '#{msg.text}'"
    Rails.env.production? ? ping(error) : raise(Strategy::Missing, error)
  end
end
