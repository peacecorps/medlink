class PromptForReceiptAcknowledgementJob < ApplicationJob
  def perform response
    ReceiptAckPrompt.new(response).send
    true
  end
end
