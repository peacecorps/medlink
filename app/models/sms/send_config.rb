module Sms
  class SendConfig
    attr_reader :last

    def deliver sms:, twilio: nil
      if @method == :deliver
        # :nocov:
        twilio.client.messages.create sms
        # :nocov:
      else
        @last = sms
      end
    end

    def method= m
      @method = m.to_sym
    end
  end
end
