class NotificationCenter
  def self.configure
    new.tap { |ns| yield ns }
  end

  def initialize
    @handlers   = {}
    @unhandlers = []
  end

  def on msg, &block
    handlers[msg] ||= []
    handlers[msg].push block
  end

  def unhandled &block
    unhandlers.push block
  end

  def send key, msg
    if handlers.include? key
      handlers[key].each { |h| h.call msg }
    else
      unhandlers.each { |h| h.call key, msg }
    end
  end

  private

  attr_reader :handlers, :unhandlers
end


Notification = NotificationCenter.configure do |c|
  slack = ->(msg) { Rails.configuration.slackbot.info msg }
  ping  = ->(msg) { Rails.configuration.pingbot.info msg  }
  log   = ->(msg) { Rails.logger.info msg                 }

  c.on :sending_country_sms,    &slack
  c.on :announcement_scheduled, &ping
  c.on :error_in_job,           &ping
  c.on :flag_for_followup,      &ping
  c.on :slow,                   &ping
  c.on :spam_warning,           &ping
  c.on :unrecognized_sms,       &ping
  c.on :sending_response,       &log
  c.on :prompt_for_ack,         &log
  c.on :delivery_failure,       &log

  c.unhandled do |key, msg|
    error = "Unhandled `#{key}` - '#{msg}'"
    Rails.env.production? ? ping(error) : raise(error)
  end
end
