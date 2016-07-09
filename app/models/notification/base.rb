module Notification
  class Base
    def self.key
      name.split("::").last.underscore.to_sym
    end

    def self.description
      name.split("::").last.underscore.gsub("_", " ").capitalize
    end

    def text
      raise "Expected `#{self.class}` to define `text`"
    end

    def slack
      text
    end
  end
end
