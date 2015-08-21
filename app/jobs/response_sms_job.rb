class ResponseSMSJob < ApplicationJob
  def perform response
    Rails.logger.info "Sending SMS for response ##{response.id}"
    user = response.user
    return unless user.try :textable?
    user.send_text response.sms_instructions
  end
end
