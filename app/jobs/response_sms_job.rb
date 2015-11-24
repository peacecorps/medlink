class ResponseSMSJob < ApplicationJob
  def perform response
    Rails.logger.info "Sending SMS for response ##{response.id}"
    user = response.user
    return unless user.try :textable?
    sms = user.send_text response.sms_instructions
    response.update! message: sms
  end
end
