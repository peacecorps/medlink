module Sms
  class SendConfig
    include Enumerable

    def initialize
      @stored = []
    end

    def each
      @stored.each { |m| yield m }
    end

    def clear
      @stored.clear
    end

    def deliver sms:, twilio: nil
      if @method == :deliver
        twilio.client.messages.create sms
      else
        @stored.push sms
      end
    end

    def method= m
      @method = m.to_sym
    end
  end
end
