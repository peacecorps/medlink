class PromptForReceiptAcknowledgementJob < ApplicationJob
  def perform response
    # TODO: make sure this doesn't apply if the response has been acked or flagged
    return unless response.needs_receipt_reminder?
    response.send_receipt_reminder!
  end
end
