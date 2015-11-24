class PromptForReceiptAcknowledgementJob < ApplicationJob
  def perform response
    return unless response.needs_receipt_reminder?
    response.send_receipt_reminder!
  end
end
