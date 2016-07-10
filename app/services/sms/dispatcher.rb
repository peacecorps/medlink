class SMS
  class Dispatcher
    Handlers = [ Empty, SupplyList, Example, Help, ReceiptRecorder, OrderPlacer ]

    def initialize sms:
      @sms = sms
    end

    def handler
      Handlers.each do |klass|
        h = klass.new sms: sms
        return h if h.valid?
      end
    end

    private

    attr_reader :sms
  end
end
