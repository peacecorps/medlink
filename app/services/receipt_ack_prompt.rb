class ReceiptAckPrompt
  def initialize response
    @response = response
  end

  def send
    # TODO: make sure this doesn't apply if the response has been acked or flagged
  end

  private

  attr_reader :response
end
