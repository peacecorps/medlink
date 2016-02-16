module Sms
  class SendConfig
    attr_reader :last

    STORE    = :store
    DELIVERY = :delivery

    def deliver sms:, twilio: nil
      if @method == DELIVERY
        # :nocov:
        twilio.client.messages.create sms
        # :nocov:
      else
        @last = sms
      end
    end

    def method= m
      if [STORE, DELIVERY].include? m.to_sym
        @method = m.to_sym
      else
        raise "Unknown delivery method: `#{method}`"
      end
    end
  end
end
