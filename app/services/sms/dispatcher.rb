class SMS
  class Dispatcher
    Handlers = [ Empty, SupplyList, ReceiptRecorder, OrderPlacer ]

    def initialize twilio:, sms:
      @twilio, @sms = twilio, sms
    end

    def handler
      Handlers.each do |klass|
        h = klass.new twilio: twilio, sms: sms
        return h if h.valid?
      end
    end

    private

    attr_reader :twilio, :sms
  end
end
