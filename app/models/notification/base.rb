module Notification
  class Base
    include Rails.application.routes.url_helpers

    def self.key
      name.split("::").last.underscore.to_sym
    end

    def self.description
      name.split("::").last.underscore.gsub("_", " ").capitalize
    end

    # :nocov:
    def text
      raise "Expected `#{self.class}` to define `text`"
    end

    def email
      raise "Expected `#{self.class}` to define `email`"
    end

    def sms
      raise "Expected `#{self.class}` to define `sms`"
    end
    # :nocov:

    def slack
      text
    end

    def for_user?
      !!@for_user
    end

    private

    def slack_link label, path
      "<#{path}|#{label}>"
    end
  end
end
