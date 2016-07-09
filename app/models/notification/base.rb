module Notification
  class Base
    include Rails.application.routes.url_helpers

    def self.key
      name.split("::").last.underscore.to_sym
    end

    def self.description
      name.split("::").last.underscore.gsub("_", " ").capitalize
    end

    def text
      # :nocov:
      raise "Expected `#{self.class}` to define `text`"
      # :nocov:
    end

    def slack
      text
    end

    private

    def slack_link label, path
      "<#{label}|#{path}>"
    end
  end
end
