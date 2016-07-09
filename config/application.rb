require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

NoOp = ->(*args, &block) { block.call if block }

class Container
  include Dry::Container::Mixin

  # Items should resolve to service objects (with `#call` as their api), but we register
  # procs (so that we can defer builing until the app is loaded).
  # Rather than getting lost in `call`s, we'll use this custom resolver
  configure do |config|
    config.registry = ->(container, key, builder, options) { container[key] = builder }
    config.resolver = ->(container, key) {
      container[:_cache]      ||= Concurrent::Hash.new
      container[:_cache][key] ||= container.fetch(key).call
    }
  end

  def purge key
    return unless _container[:_cache]
    _container[:_cache].delete key
  end
end

module Medlink
  class Application < Rails::Application
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    config.encoding = "utf-8"

    config.filter_parameters += [:password]

    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true

    config.assets.version = '1.0'
    config.assets.quiet = true

    I18n.config.enforce_available_locales = false

    config.autoload_paths += %W(#{config.root}/lib)

    config.container = Container.new.tap do |c|
      c.register :notifier, -> { Notifier.load }
      c.register :slackbot, -> { Slackbot::Test.build }
      c.register :pingbot,  -> { Slackbot::Test.build }
      c.register :slow_request_notifier, ->{ NoOp }
      c.register :sms_deliverer,         ->{ NoOp }
    end
  end

  %i(
      notifier
      pingbot
      slackbot
      slow_request_notifier
      sms_deliverer
  ).each do |key|
    define_singleton_method key do
      Rails.configuration.container.resolve(key)
    end
  end

  def self.notify msg
    self.notifier.call msg
  end

  def self.redis
    Sidekiq.redis { |r| yield r }
  end

  def self.reload key
    Rails.configuration.container.purge key
  end
end
