require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

NoOp = ->(*args, &block) { block ? block.call : NoOp }

module Medlink
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

    %i(
      notifier
      order_responder
      pingbot
      report_uploader
      slackbot
      slow_request_notifier
      sms_deliverer
    ).each do |key|
      Medlink.define_singleton_method key do
        Rails.configuration.container.resolve key
      end

      define_method key do |&builder|
        builder ? register(key, &builder) : resolve(key)
      end
    end

    def self.build
      new.tap { |c| yield c }
    end

    def purge key
      return unless _container[:_cache]
      _container[:_cache].delete key
    end
  end

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

    config.paths.add "lib", eager_load: true

    #config.reform.validations = :dry

    config.container = Container.build do |c|
      c.notifier              { Notifier.build }
      c.order_responder       { OrderResponder.build }
      c.pingbot               { Slackbot::Test.build }
      c.report_uploader       { ReportUploader.build }
      c.slackbot              { Slackbot::Test.build }
      c.slow_request_notifier { NoOp }
      c.sms_deliverer         { NoOp }
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
